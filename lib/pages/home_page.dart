import 'package:bluesky/app_bsky_feed_post.dart';
import 'package:bluesky/bluesky.dart';
import 'package:bluesky/core.dart';
import 'package:bluesky/app_bsky_feed_defs.dart';
import 'package:bluesky/com_atproto_repo_strongref.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumina/components/auth.dart';
import 'package:lumina/components/side_bar.dart';

class HomePage extends StatefulWidget {
  final Bluesky bsky;
  
  const HomePage({super.key, required this.bsky});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FeedViewPost> _posts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();
  String? _cursor;

  @override
  void initState() {
    super.initState();
    _loadTimeline();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  Future<void> _loadTimeline() async {
    try {
      final timeline = await widget.bsky.feed.getTimeline(limit: 50);
      setState(() {
        _posts = timeline.data.feed;
        _cursor = timeline.data.cursor;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load timeline: $e')),
        );
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || _cursor == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final timeline = await widget.bsky.feed.getTimeline(
        limit: 25,
        cursor: _cursor,
      );
      setState(() {
        _posts.addAll(timeline.data.feed);
        _cursor = timeline.data.cursor;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshTimeline() async {
    setState(() {
      _cursor = null;
    });
    await _loadTimeline();
  }

  Future<void> _likePost(FeedViewPost post) async {
    try {
      await widget.bsky.feed.like.create(
        subject: RepoStrongRef(
          uri: post.post.uri,
          cid: post.post.cid,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post liked!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to like post: $e')),
      );
    }
  }

  Future<void> _repost(FeedViewPost post) async {
    try {
      await widget.bsky.feed.repost.create(
        subject: RepoStrongRef(
          uri: post.post.uri,
          cid: post.post.cid,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post reposted!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to repost: $e')),
      );
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) {
      return 'now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  Widget _buildActionButton(Icon icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 29, 133, 218),
              ),
            )
          : Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 248, 247),
                    border: BorderDirectional(
                      end: BorderSide(
                      color: const Color.fromARGB(255, 151, 151, 151),
                      width: 0.2,
                    )
                    ),
                  ),
                  width: 235,
                  child: const SideBar(),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshTimeline,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _posts.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                  if (index == _posts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    );
                  }

                  final post = _posts[index];
                  final record = post.post.record;
                  final timestamp = DateTime.parse(post.post.indexedAt.toString());

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color.fromARGB(255, 151, 151, 151),
                        width: 0.2,
                      ),
                      color: Colors.white/*const Color.fromARGB(255, 249, 248, 247)*/,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.07),
                          spreadRadius: 8,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: post.post.author.avatar != null
                                        ? NetworkImage(post.post.author.avatar.toString())
                                        : null,
                                    backgroundColor: const Color.fromARGB(255, 29, 133, 218),
                                    child: post.post.author.avatar == null
                                        ? Text(
                                            post.post.author.displayName?.isNotEmpty == true
                                                ? post.post.author.displayName![0].toUpperCase()
                                                : post.post.author.handle[0].toUpperCase(),
                                            style: const TextStyle(color: Colors.white),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.post.author.displayName ?? post.post.author.handle,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '@${post.post.author.handle}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _formatTimestamp(timestamp),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                FeedPostRecord.fromJson(record as Map<String, dynamic>).text ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                                maxLines: null,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildActionButton(
                                      const Icon(FluentIcons.arrow_reply_24_regular),
                                      Colors.grey[600]!,
                                      () {},
                                    ),
                                    _buildActionButton(
                                      const Icon(FluentIcons.arrow_repeat_all_24_regular),
                                      Colors.grey[600]!,
                                      () => _repost(post),
                                    ),
                                    _buildActionButton(
                                      const Icon(FluentIcons.heart_24_regular),
                                      Colors.grey[600]!,
                                      () => _likePost(post),
                                    ),
                                    _buildActionButton(
                                      const Icon(FluentIcons.share_24_regular),
                                      Colors.grey[600]!,
                                      () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}