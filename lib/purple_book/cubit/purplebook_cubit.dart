import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/modules/comment_likes_module.dart';
import 'package:purplebook/modules/comments_module.dart';
import 'package:purplebook/modules/feed_moduel.dart';
import 'package:purplebook/modules/friend_recommendation_module.dart';
import 'package:purplebook/modules/friends_request_module.dart';
import 'package:purplebook/modules/likes_module.dart';
import 'package:purplebook/modules/notifications_module.dart';
import 'package:purplebook/modules/user_comments_module.dart';
import 'package:purplebook/modules/user_friends_module.dart';
import 'package:purplebook/modules/user_posts_module.dart';
import 'package:purplebook/modules/user_profile_module.dart';
import 'package:purplebook/modules/view_post_module.dart';
import 'package:purplebook/network/local/cach_helper.dart';
import 'package:purplebook/network/remote/dio_helper.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/feed_screen.dart';
import 'package:purplebook/purple_book/friends_screen.dart';
import 'package:purplebook/purple_book/notification_screen.dart';
import 'package:purplebook/purple_book/account_screen.dart';
import '../../components/end_points.dart';

class PurpleBookCubit extends Cubit<PurpleBookState> {
  PurpleBookCubit() : super(InitialPurpleBookState());

  static PurpleBookCubit get(context) => BlocProvider.of(context);

  List<String> bar = ['Feed', 'Friends', 'Notification', 'Account'];
  List<Widget> bottomNavItem = [
    FeedScreen(),
    const FriendsScreen(),
    const NotificationScreen(),
    AccountScreen()
  ];

  Object dropDownValue = 'date';

  int indexBottom = 0;
  //* this indexWidget for buttons [posts,comments,friends] in account screen
  int indexWidget = 0;
  void changeBottom(index) {
    indexBottom = index;
    indexWidget = 0;
    emit(ChangeBottomState());
  }

  FeedModule? feedModule;
  List<bool>? isLikePost;
  List<int>? likesCount;
  int skip = 0;
  bool isEndFeed = false;
  Future<void> getFeed() async {
    isLikePost = [];
    likesCount = [];
    skip = 5;
    isEndFeed = false;
    emit(GetFeedLoadingState());
    return await DioHelper.getData(url: '$feed?skip=0&limit=5', token: token)
        .then((value) {
      feedModule = FeedModule.fromJson(value.data);
      if (feedModule!.posts!.length < 5) {
        isEndFeed = true;
      } else {
        isEndFeed = false;
      }
      for (var element in feedModule!.posts!) {
        isLikePost!.add(element.likedByUser!);
        likesCount!.add(element.likesCount!);
      }
      emit(GetFeedSuccessState(feedModule!));
    }).catchError((error) {
      emit(GetFeedErrorState());
    });
  }

  Future<void> getMoreFeed() async {
    emit(GetMoreFeedLoadingState());
    return await DioHelper.getData(
            url: '$feed?skip=$skip&limit=5', token: token)
        .then((value) {
      if (value.data['posts'].isNotEmpty) {
        skip += 5;
        value.data['posts'].forEach((v) {
          feedModule!.posts!.add(Posts.fromJson(v));
        });
        isLikePost = [];
        likesCount = [];
        for (var element in feedModule!.posts!) {
          isLikePost!.add(element.likedByUser!);
          likesCount!.add(element.likesCount!);
        }
      } else {
        isEndFeed = true;
      }
      emit(GetMoreFeedSuccessState());
    }).catchError((error) {
      emit(GetMoreFeedErrorState());
    });
  }

  void editPosts({required String edit, required String id}) {
    emit(EditPostLoadingState());
    DioHelper.patchData(url: '$posts$id', data: {'content': edit}, token: token)
        .then((value) {
      emit(EditPostSuccessState());
    }).catchError((error) {
      emit(EditPostErrorState());
    });
  }

  ViewPostModule? postView;
  void viewPosts({required String id}) {
    emit(ViewPostLoadingState());
    DioHelper.getData(url: '$posts$id', token: token).then((value) {
      postView = ViewPostModule.fromJson(value.data);
      isLikeSinglePost=postView!.post!.likedByUser!;
      likePostCount=postView!.post!.likesCount!;
      emit(ViewPostSuccessState());
    }).catchError((error) {
      emit(ViewPostErrorState());
    });
  }

  bool? isLikeSinglePost;
  int? likePostCount;
  void likeSinglePost(){
    emit(AddLikeSinglePostLoadingState());
    if(!isLikeSinglePost!){
      DioHelper.postData(url: '$posts${postView!.post!.sId}$likePost_2',token: token).then((value) {
        emit(AddLikeSinglePostSuccessState());
      }).catchError((error){
        emit(AddLikeSinglePostErrorState());
      });
    }
    else{
      DioHelper.deleteData(url: '$posts${postView!.post!.sId}$likePost_2',token: token).then((value) {
        emit(DeleteLikeSinglePostSuccessState());
      }).catchError((error){
        emit(DeleteLikeSinglePostErrorState());
      });
    }
  }

  void changeLikeSinglePost(){
    if(isLikeSinglePost!){
      isLikeSinglePost=!isLikeSinglePost!;
      likePostCount=likePostCount!+1;
    }
    else{
      isLikeSinglePost=!isLikeSinglePost!;
      likePostCount=likePostCount!-1;
    }
    emit(ChangeLikePostState());
  }

  void likePost({required String id, required int index}) {
    emit(AddLikePostLoadingState());
    if (!feedModule!.posts![index].likedByUser!) {
      DioHelper.postData(url: '$posts$id$likePost_2', token: token)
          .then((value) {
        emit(AddLikePostSuccessState());
      }).catchError((error) {
        emit(AddLikePostErrorState());
      });
    } else {
      DioHelper.deleteData(url: '$posts$id$likePost_2', token: token)
          .then((value) {
        emit(DeleteLikePostSuccessState());
      }).catchError((error) {
        emit(DeleteLikePostErrorState());
      });
    }
  }
  //
  // void likePostFromViewPost({required String id}) {
  //   emit(AddLikePostFromViewLoadingState());
  //   if (!postView!.post!.likedByUser!) {
  //     DioHelper.postData(url: '$posts$id$likePost_2', token: token)
  //         .then((value) {
  //       emit(AddLikePostFromViewSuccessState());
  //     }).catchError((error) {
  //       emit(AddLikePostFromViewErrorState());
  //     });
  //   } else {
  //     DioHelper.deleteData(url: '$posts$id$likePost_2', token: token)
  //         .then((value) {
  //       emit(DeleteLikePostFromViewSuccessState());
  //     }).catchError((error) {
  //       emit(DeleteLikePostFromViewErrorState());
  //     });
  //   }
  // }

  //* change color icon likes posts
  void changeColorIcon(int index) {
    if (isLikePost![index]) {
      isLikePost![index] = !isLikePost![index];
      likesCount![index]--;
    } else {
      likesCount![index]++;
      isLikePost![index] = !isLikePost![index];
    }
    emit(ChangeColorIconState());
  }

  //* Add Image to Post
  File? postImage;
  final ImagePicker _imagePicker = ImagePicker();
  Future imagePost(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      postImage = File(image.path);
      emit(GetPostImageSuccessState());
    } else {
      emit(GetPostImageErrorState());
    }
  }

  void newPost({required String content}) {
    emit(AddNewPostLoadingState());
    FormData formData = FormData.fromMap({
      "content": content,
      "image":
          postImage != null ? MultipartFile.fromFileSync(postImage!.path) : null
    });
    DioHelper.postFormData(url: userPosts, token: token, data: formData)
        .then((value) {
      emit(AddNewPostSuccessState());
    }).catchError((error) {
      emit(AddNewPostErrorState());
    });
  }

  Future<void> deletePost({required String id}) async {
    emit(PostDeleteLoadingState());
    return await DioHelper.deleteData(url: '$posts$id', token: token)
        .then((value) {
      getFeed();
      emit(PostDeleteSuccessState());
    }).catchError((error) {
      emit(PostDeleteErrorState());
    });
  }

  void deletePhotoPost() {
    postImage = null;
    emit(DeletePhotoPostState());
  }

  LikesModule? likeModule;
  Future<void> getLikesPost({required String id}) async {
    emit(GetLikePostLoadingState());
    return await DioHelper.getData(url: '$posts$id$likePost_2', token: token)
        .then((value) {
      likeModule = LikesModule.fromJson(value.data);
      emit(GetLikePostSuccessState());
    }).catchError((error) {
      emit(GetLikePostErrorState());
    });
  }

  CommentsModule? comment;
  List<bool>? isLikeComment = [];
  List<int>? likeCommentCount = [];
  int skipComments = 0;
  bool isEndComments = false;
  void getComments({required String id, String sort = 'date'}) {
    emit(GetCommentPostLoadingState());
    DioHelper.getData(
            url: '$posts$id$comments_2?skip=0&limit=5&sort=$dropDownValue',
            token: token)
        .then((value) {
      skipComments = 5;
      comment = CommentsModule.fromJson(value.data);
      if (comment!.comments!.length < 5) {
        isEndComments = true;
      } else {
        isEndComments = false;
      }
      for (var element in comment!.comments!) {
        isLikeComment!.add(element.likedByUser!);
        likeCommentCount!.add(element.likesCount!);
      }
      emit(GetCommentPostSuccessState());
    }).catchError((error) {
      emit(GetCommentPostErrorState());
    });
  }

  void getMoreComments({required String id, String sort = 'date'}) {
    emit(GetMoreCommentPostLoadingState());
    DioHelper.getData(
            url: '$posts$id$comments_2?skip=5&limit=1&sort=$dropDownValue',
            token: token)
        .then((value) {
      if (value.data['comments'].isNotEmpty) {
        value.data['comments'].forEach((v) {
          comment!.comments!.add(Comments.fromJson(v));
        });
        isLikeComment = [];
        likeCommentCount = [];
        for (var element in comment!.comments!) {
          isLikeComment!.add(element.likedByUser!);
          likeCommentCount!.add(element.likesCount!);
        }
        if (value.data['comments'].length < 5) isEndComments = true;
      } else {
        isEndComments = true;
      }
      skip += 5;
      emit(GetMoreCommentPostSuccessState());
    }).catchError((error) {
      emit(GetMoreCommentPostErrorState());
    });
  }

  CommentLikesModule? commentLikes;
  Future<void> getLikeComments(
      {required String commentId, required String postId}) async {
    emit(GetLikeCommentsLoadingState());
    return await DioHelper.getData(
            url: '$posts$postId$comments$commentId$likePost_2', token: token)
        .then((value) {
      commentLikes = CommentLikesModule.fromJson(value.data);
      emit(GetLikeCommentsSuccessState());
    }).catchError((error) {
      emit(GetLikeCommentsErrorState());
    });
  }

  Future<void> likeComment(
      {required String postId,
      required String commentId,
      required int index}) async {
    emit(LikeCommentPostLoadingState());
    if (!isLikeComment![index]) {
      return await DioHelper.postData(
              url: '$posts$postId$comments$commentId$likePost_2', token: token)
          .then((value) {
        emit(AddLikeCommentPostSuccessState());
      }).catchError((error) {
        emit(AddLikeCommentPostErrorState(error));
      });
    } else {
      return await DioHelper.deleteData(
              url: '$posts$postId$comments_2/$commentId$likePost_2',
              token: token)
          .then((value) {
        emit(DeleteLikeCommentPostSuccessState());
      }).catchError((error) {
        emit(DeleteLikeCommentPostErrorState(error));
      });
    }
  }

  void changeLikeComment(int index) {
    if (isLikeComment![index]) {
      isLikeComment![index] = !isLikeComment![index];
      likeCommentCount![index]--;
    } else {
      likeCommentCount![index]++;
      isLikeComment![index] = !isLikeComment![index];
    }
    emit(ChangeLikeCommentState());
  }

  void deleteComment({required String postId, required String commentId}) {
    emit(DeleteCommentPostLoadingState());
    DioHelper.deleteData(url: '$posts$postId$comments$commentId', token: token)
        .then((value) {
      getComments(id: postId);
      emit(DeleteCommentPostSuccessState());
    }).catchError((error) {
      emit(DeleteCommentPostErrorState());
    });
  }

  void addComment({required String postId, required String text}) {
    emit(AddCommentPostLoadingState());
    DioHelper.postData(
        url: '$posts$postId$comments_2',
        token: token,
        data: {'content': text}).then((value) {
      getComments(id: postId);
      emit(AddCommentPostSuccessState());
    }).catchError((error) {
      emit(AddCommentPostErrorState());
    });
  }

  Future<void> editComment(
      {required String postId,
      required String commentId,
      required String text}) async {
    emit(EditCommentPostLoadingState());
    return await DioHelper.patchData(
            url: '$posts$postId$comments_2/$commentId',
            data: {'content': text},
            token: token)
        .then((value) {
      getComments(id: postId);
      emit(EditCommentPostSuccessState());
    }).catchError((error) {
      emit(EditCommentPostErrorState());
    });
  }

  UserPostsModule? userPost;
  List<bool>? isLikeUserPost = [];
  List<int>? likesUserCount = [];
  int skipUserPost = 0;
  bool isEndUserPost = false;
  Future<void> getUserPosts(
      {required String userId, String sort = 'date'}) async {
    emit(GetUserPostLoadingState());
    isLikeUserPost=[];
    likesUserCount=[];
    return await DioHelper.getData(
            url: '$users$userId$userPosts?limit=5&skip=0&sort=$dropDownValue',
            token: token)
        .then((value) {
      if (value.data['posts'].length < 5) {
        isEndUserPost = true;
      } else {
        isEndUserPost = false;
      }
      skipUserPost = 5;
      userPost = UserPostsModule.fromJson(value.data);
      for (var element in userPost!.posts!) {
        isLikeUserPost!.add(element.likedByUser!);
        likesUserCount!.add(element.likesCount!);
      }
      emit(GetUserPostSuccessState());
    }).catchError((error) {
      emit(GetUserPostErrorState());
    });
  }

  Future<void> getMoreUserPosts({required String userId}) async {
    emit(GetMoreUserPostLoadingState());
    return await DioHelper.getData(
            url:
                '$users$userId$userPosts?limit=5&skip=$skipUserPost&sort=$dropDownValue',
            token: token)
        .then((value) {
      if (value.data['posts'].isNotEmpty) {
        value.data['posts'].forEach((v) {
          userPost!.posts!.add(UserPosts.fromJson(v));
        });
        isLikeUserPost=[];
        likesUserCount=[];
        for (var element in userPost!.posts!) {
          isLikeUserPost!.add(element.likedByUser!);
          likesUserCount!.add(element.likesCount!);
        }
        if (value.data['posts'].length < 5) isEndUserPost = true;
      } else {
        isEndUserPost = true;
      }
      skipUserPost += 5;
      emit(GetMoreUserPostSuccessState());
    }).catchError((error) {
      emit(GetMoreUserPostErrorState());
    });
  }

  void likeUserPost(
      {required String id, required int index, required String userId}) {
    emit(AddLikeUserPostLoadingState());
    if (!isLikeUserPost![index]) {
      DioHelper.postData(url: '$posts$id$likePost_2', token: token)
          .then((value) {
        emit(AddLikeUserPostSuccessState());
      }).catchError((error) {
        emit(AddLikeUserPostErrorState(error));
      });
    } else {
      DioHelper.deleteData(url: '$posts$id$likePost_2', token: token)
          .then((value) {
        emit(DeleteLikeUserPostSuccessState());
      }).catchError((error) {
        emit(DeleteLikeUserPostErrorState(error));
      });
    }
  }

  void changeLikePostUser(int index) {
    if (isLikeUserPost![index]) {
      isLikeUserPost![index] = !isLikeUserPost![index];
      likesUserCount![index]--;
    } else {
      likesUserCount![index]++;
      isLikeUserPost![index] = !isLikeUserPost![index];
    }
    emit(ChangeColorUSerLikeState());
  }

  void editUserPosts(
      {required String edit, required String id, required String userId}) {
    emit(EditUserPostLoadingState());
    DioHelper.patchData(url: '$posts$id', data: {'content': edit}, token: token)
        .then((value) {
      getUserPosts(userId: userId);
      emit(EditUserPostSuccessState());
    }).catchError((error) {
      emit(EditUserPostErrorState());
    });
  }

  UserProfileModule? userProfile;
  void getUserProfile({required String id}) {
    emit(GetUserProfileLoadingState());
    DioHelper.getData(url: '$users$id', token: token).then((value) {
      userProfile = UserProfileModule.fromJson(value.data);
      emit(GetUserProfileSuccessState());
    }).catchError((error) {
      emit(GetUserProfileErrorState());
    });
  }

  UserCommentsModule? userComments;
  int skipUserComments = 0;
  bool isEndUserComments = false;
  void getUserComments({required String id, String sort = 'date'}) {
    emit(GetUserCommentsLoadingState());
    isLikeComment=[];
    likeCommentCount=[];
    DioHelper.getData(
            url: '$users$id$comments_2?limit=5&skip=0&sort=$dropDownValue',
            token: token)
        .then((value) {
      if (value.data['comments'].length < 5) {
        isEndUserComments = true;
      } else {
        isEndUserComments = false;
      }
      userComments = UserCommentsModule.fromJson(value.data);
      skipUserComments = 5;
      for (var element in userComments!.comments!) {
        isLikeComment!.add(element.likedByUser!);
        likeCommentCount!.add(element.likesCount!);
      }
      emit(GetUserCommentsSuccessState());
    }).catchError((error) {
      emit(GetUserCommentsErrorState());
    });
  }

  void getMoreUserComments({required String id}) {
    emit(GetMoreUserCommentsLoadingState());
    DioHelper.getData(
            url:
                '$users$id$comments_2?limit=5&skip=$skipUserComments&sort=$dropDownValue',
            token: token)
        .then((value) {
      if (value.data['comments'].isNotEmpty) {
        value.data['comments'].forEach((v) {
          userComments!.comments!.add(UserComments.fromJson(v));
        });
        likeCommentCount = [];
        for (var element in userComments!.comments!) {
          isLikeComment!.add(element.likedByUser!);
          likeCommentCount!.add(element.likesCount!);
        }
        if (value.data['comments'].length < 5) isEndUserComments = true;
      } else {
        isEndUserComments = true;
      }
      skipUserComments += 5;
      emit(GetMoreUserCommentsSuccessState());
    }).catchError((error) {
      emit(GetMoreUserCommentsErrorState());
    });
  }

  UserFriendsModule? userFriends;
  void getUSerFriends({required String id}) {
    emit(GetUserFriendsLoadingState());
    DioHelper.getData(url: '$users$id$friends', token: token).then((value) {
      userFriends = UserFriendsModule.fromJson(value.data);
      emit(GetUserFriendsSuccessState());
    }).catchError((error) {
      emit(GetUserFriendsErrorState());
    });
  }

  File? profileImage;
  Future imageProfile(ImageSource source) async {
    final image = await _imagePicker.pickImage(source: source);
    if (image != null) {
      profileImage = File(image.path);
      emit(GetProfileImageSuccessState());
    } else {
      emit(GetProfileImageErrorState());
    }
  }

  void deletePhotoProfile() {
    profileImage = null;
    emit(DeletePhotoProfileState());
  }

  void editUserProfile(
      {required String id,
      required String firstName,
      required String lastName}) {
    emit(UpdateUserProfileLoadingState());
    FormData formData = FormData.fromMap({
      "firstName": firstName,
      "lastName": lastName,
      "profilePicture": profileImage != null
          ? MultipartFile.fromFileSync(profileImage!.path)
          : null
    });
    DioHelper.patchFormData(url: '$users$id', data: formData, token: token)
        .then((value) {
      deletePhotoProfile();
      getUserProfile(id: id);
      emit(UpdateUserProfileSuccessState());
    }).catchError((error) {
      emit(UpdateUserProfileErrorState());
    });
  }

  Future<void> sendRequestFriend({required String id}) async {
    emit(SendRequestLoadingState());
    return await DioHelper.postData(
            url: '$users$id$friendRequests', token: token)
        .then((value) {
      emit(SendRequestSuccessState());
    }).catchError((error) {
      emit(SendRequestErrorState());
    });
  }

  Future<void> cancelSendRequestFriend({required String receiveId}) async {
    emit(CancelSendRequestLoadingState());
    return await DioHelper.deleteData(
            url: '$users$userId$cancelFriendRequests$receiveId', token: token)
        .then((value) {
      emit(CancelSendRequestSuccessState());
    }).catchError((error) {
      emit(CancelSendRequestErrorState());
    });
  }

  Future<void> cancelFriend({required String receiveId}) async {
    emit(CancelFriendLoadingState());
    return await DioHelper.deleteData(
            url: '$users$userId$friends/$receiveId', token: token)
        .then((value) {
      emit(CancelFriendSuccessState());
    }).catchError((error) {
      emit(CancelFriendErrorState());
    });
  }

  void removeRequest({required String id}) {
    emit(RemoveFriendRequestLoadingState());
    DioHelper.deleteData(url: '$users$userId$friendRequests/$id', token: token)
        .then((value) {
      getFriendRequest();
      emit(RemoveFriendRequestSuccessState());
    }).catchError((error) {
      emit(RemoveFriendRequestErrorState());
    });
  }

  Future<void> acceptFriendRequest({required String id}) async {
    emit(AcceptFriendRequestLoadingState());
    return await DioHelper.postData(
            url: '$users$userId$friends/$id', token: token)
        .then((value) {
      getFriendRequest();
      getFriendRecommendation();
      emit(AcceptFriendRequestSuccessState());
    }).catchError((error) {
      emit(AcceptFriendRequestErrorState());
    });
  }

  FriendsRequestModule? friendRequest;
  int? friendeRequestCount;
  void getFriendRequest() {
    emit(GetFriendsRequestLoadingState());
    DioHelper.getData(url: '$users$userId$friendRequests', token: token)
        .then((value) {
      friendRequest = FriendsRequestModule.fromJson(value.data);
      emit(GetFriendsRequestSuccessState());
    }).catchError((error) {
      emit(GetFriendsRequestErrorState());
    });
  }

  void getFriendRequestFromAnyScreen() {
    friendeRequestCount = 0;
    emit(GetFriendsRequestAllScreenLoadingState());
    DioHelper.getData(url: '$users$userId$friendRequests', token: token)
        .then((value) {
      friendRequest = FriendsRequestModule.fromJson(value.data);
      for (var element in friendRequest!.friendRequests!) {
        if (element.viewed == false) {
          friendeRequestCount = friendeRequestCount! + 1;
        }
      }
      emit(GetFriendsRequestAllScreenSuccessState());
    }).catchError((error) {
      emit(GetFriendsRequestAllScreenErrorState());
    });
  }

  FriendRecommendationModule? friendsRecommendation;
  void getFriendRecommendation() {
    emit(GetFriendRecommendationLoadingState());
    DioHelper.getData(url: '$users$userId$friendRecommendation', token: token)
        .then((value) {
      friendsRecommendation = FriendRecommendationModule.fromJson(value.data);
      emit(GetFriendRecommendationSuccessState());
    }).catchError((error) {
      emit(GetFriendRecommendationErrorState());
    });
  }

  void viewedAllFriendRequest() {
    emit(ViewedFriendRequestLoadingState());
    DioHelper.patchData(url: '$users$userId$friendRequests/', token: token)
        .then((value) {
      getFriendRequest();
      emit(ViewedFriendRequestSuccessState());
    }).catchError((error) {
      emit(ViewedFriendRequestErrorState());
    });
  }

  void viewedAllNotifications() {
    emit(ViewedAllNotificationsLoadingState());
    DioHelper.patchData(url: notifications, token: token).then((value) {
      emit(ViewedAllNotificationsSuccessState());
    }).catchError((error) {
      emit(ViewedAllNotificationsErrorState());
    });
  }

  NotificationsModule? notificationsModule;
  int notificationsCount = 0;
  void getNotifications() {
    notificationsCount = 0;
    emit(GetNotificationsLoadingState());
    DioHelper.getData(url: notifications, token: token).then((value) {
      notificationsModule = NotificationsModule.fromJson(value.data);
      emit(GetNotificationsSuccessState());
    }).catchError((error) {
      emit(GetNotificationsErrorState());
    });
  }

  void getNotificationsFromAnyScreen() {
    notificationsCount = 0;
    emit(GetNotifFromAnyScreenLoadingState());
    DioHelper.getData(url: notifications, token: token).then((value) {
      notificationsModule = NotificationsModule.fromJson(value.data);
      for (var element in notificationsModule!.notifications!) {
        if (element.viewed == false) {
          notificationsCount = notificationsCount + 1;
        } else {
          break;
        }
      }
      emit(GetNotifFromAnyScreenSuccessState());
    }).catchError((error) {
      emit(GetNotifFromAnyScreenErrorState());
    });
  }

  void deleteUser() {
    emit(DeleteUserLoadingState());
    DioHelper.deleteData(url: '$users$userId', token: token).then((value) {
      emit(DeleteUserSuccessState());
    }).catchError((error) {
      emit(DeleteUserErrorState());
    });
  }
}
