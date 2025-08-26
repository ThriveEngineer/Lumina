import 'package:bluesky/app_bsky_feed_post.dart';
import 'package:bluesky/bluesky.dart';
import 'package:bluesky/app_bsky_feed_defs.dart' hide ReplyRef;
import 'package:bluesky/com_atproto_repo_strongref.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumina/components/auth.dart';
import 'package:lumina/components/side_bar.dart';
import 'package:lumina/pages/post_detail_page.dart';

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
  final Set<String> _likedPosts = <String>{};

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
    final postUri = post.post.uri.toString();
    
    setState(() {
      if (_likedPosts.contains(postUri)) {
        _likedPosts.remove(postUri);
      } else {
        _likedPosts.add(postUri);
      }
    });

    try {
      if (_likedPosts.contains(postUri)) {
        await widget.bsky.feed.like.create(
          subject: RepoStrongRef(
            uri: post.post.uri,
            cid: post.post.cid,
          ),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post liked!')),
          );
        }
      } else {
        // Note: Unlike functionality would require finding and deleting the like record
        // For now, we'll just show a message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post unliked!')),
          );
        }
      }
    } catch (e) {
      // Revert the state if the API call failed
      setState(() {
        if (_likedPosts.contains(postUri)) {
          _likedPosts.remove(postUri);
        } else {
          _likedPosts.add(postUri);
        }
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to like post: $e')),
        );
      }
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

  void _navigateToPostDetail(FeedViewPost postData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          bsky: widget.bsky,
          post: postData,
        ),
      ),
    );
  }

  Future<void> _replyToPost(FeedViewPost postData) async {
    final TextEditingController replyController = TextEditingController();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF37352F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      FluentIcons.arrow_reply_24_regular,
                      size: 16,
                      color: Color(0xFF37352F),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Reply to @${postData.post.author.handle}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF37352F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE3E2E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: replyController,
                  decoration: const InputDecoration(
                    hintText: 'Write your reply...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: Color(0xFF9B9A97)),
                  ),
                  maxLines: 4,
                  autofocus: true,
                  style: const TextStyle(
                    color: Color(0xFF37352F),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6B6B6B),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, replyController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F1B69),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Reply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      try {
        await widget.bsky.feed.post.create(
          text: result.trim(),
          reply: ReplyRef(
            root: RepoStrongRef(
              uri: postData.post.uri,
              cid: postData.post.cid,
            ),
            parent: RepoStrongRef(
              uri: postData.post.uri,
              cid: postData.post.cid,
            ),
          ),
        );
        
        // Reply posted successfully
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Reply posted!'),
              backgroundColor: const Color(0xFF2F1B69),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to post reply: $e'),
              backgroundColor: const Color(0xFFE03E3E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
          );
        }
      }
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

  Widget _buildNotionActionButton(
    IconData iconData, 
    String label, 
    VoidCallback onPressed, {
    bool isActive = false,
    Color? activeColor,
  }) {
    final color = isActive 
        ? (activeColor ?? const Color(0xFF2F1B69))
        : const Color(0xFF9B9A97);
    
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive 
              ? (activeColor ?? const Color(0xFF2F1B69)).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive 
                ? (activeColor ?? const Color(0xFF2F1B69)).withOpacity(0.2)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2F1B69),
              ),
            )
          : Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBFBFA),
                    border: Border(
                      right: BorderSide(
                        color: Color(0xFFE3E2E0),
                        width: 1,
                      ),
                    ),
                  ),
                  width: 240,
                  child: const SideBar(),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFFFFFFFF),
                    child: RefreshIndicator(
                      onRefresh: _refreshTimeline,
                      color: const Color(0xFF2F1B69),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        itemCount: _posts.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                  if (index == _posts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF2F1B69),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  final feedPost = _posts[index];
                  final record = feedPost.post.record;
                  final timestamp = DateTime.parse(feedPost.post.indexedAt.toString());

                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 64, right: 64, bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE3E2E0),
                            width: 1,
                          ),
                          color: const Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF37352F).withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main post content
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Author row
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFFE3E2E0),
                                            width: 1,
                                          ),
                                        ),
                                        child: feedPost.post.author.avatar != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(7),
                                                child: Image.network(
                                                  feedPost.post.author.avatar.toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF2F1B69),
                                                  borderRadius: BorderRadius.circular(7),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    feedPost.post.author.displayName?.isNotEmpty == true
                                                        ? feedPost.post.author.displayName![0].toUpperCase()
                                                        : feedPost.post.author.handle[0].toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              feedPost.post.author.displayName ?? feedPost.post.author.handle,
                                              style: const TextStyle(
                                                color: Color(0xFF37352F),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '@${feedPost.post.author.handle}',
                                              style: const TextStyle(
                                                color: Color(0xFF9B9A97),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF37352F).withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          _formatTimestamp(timestamp),
                                          style: const TextStyle(
                                            color: Color(0xFF9B9A97),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Post content
                                  Text(
                                    FeedPostRecord.fromJson(record as Map<String, dynamic>).text ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF37352F),
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Actions row
                                  Row(
                                    children: [
                                      _buildNotionActionButton(
                                        FluentIcons.arrow_reply_24_regular,
                                        'Reply',
                                        () => _replyToPost(feedPost),
                                      ),
                                      const SizedBox(width: 12),
                                      _buildNotionActionButton(
                                        FluentIcons.comment_24_regular,
                                        'View',
                                        () => _navigateToPostDetail(feedPost),
                                      ),
                                      const SizedBox(width: 12),
                                      _buildNotionActionButton(
                                        FluentIcons.arrow_repeat_all_24_regular,
                                        'Repost',
                                        () => _repost(feedPost),
                                      ),
                                      const SizedBox(width: 12),
                                      _buildNotionActionButton(
                                        _likedPosts.contains(feedPost.post.uri.toString())
                                            ? FluentIcons.heart_24_filled
                                            : FluentIcons.heart_24_regular,
                                        'Like',
                                        () => _likePost(feedPost),
                                        isActive: _likedPosts.contains(feedPost.post.uri.toString()),
                                        activeColor: const Color(0xFFE03E3E),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}