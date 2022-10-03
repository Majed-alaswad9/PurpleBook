import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purplebook/modules/comments_module.dart';
import 'package:purplebook/modules/feed_moduel.dart';
import 'package:purplebook/modules/friend_recommendation_module.dart';
import 'package:purplebook/modules/friends_request_module.dart';
import 'package:purplebook/modules/likes_module.dart';
import 'package:purplebook/modules/user_comments_module.dart';
import 'package:purplebook/modules/user_friends_module.dart';
import 'package:purplebook/modules/user_posts_module.dart';
import 'package:purplebook/modules/user_profile_module.dart';
import 'package:purplebook/modules/view_post_module.dart';
import 'package:purplebook/network/dio_helper.dart';
import 'package:purplebook/purple_book/cubit/purplebook_state.dart';
import 'package:purplebook/purple_book/feed_screen.dart';
import 'package:purplebook/purple_book/friends_screen.dart';
import 'package:purplebook/purple_book/notification_screen.dart';
import 'package:purplebook/purple_book/account_screen.dart';
import '../../component/end_points.dart';

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

  int indexBottom = 0;
  int indexWidget=0;
  void changeBottom(index) {
    indexBottom = index;
    indexWidget=0;
    emit(ChangeBottomState());
  }

  FeedModule? feedModule;
  List<bool>? isLikePost = [];
  List<int>? likesCount = [];

  Future<void> getFeed() async{
    emit(GetFeedLoadingState());
   return await DioHelper.getData(url: feed, token: token).then((value) {
      feedModule = FeedModule.fromJson(value.data);
      for (var element in feedModule!.posts!) {
        isLikePost!.add(element.likedByUser!);
        likesCount!.add(element.likesCount!);
      }
      emit(GetFeedSuccessState(feedModule!));
    }).catchError((error) {
      emit(GetFeedErrorState());
    });
  }

  void editPosts(
      {required String edit, required String id, required int index}) {
    emit(EditPostLoadingState());
    DioHelper.patchData(
            url: '$posts$id', data: {'content': edit}, token: token)
        .then((value) {
      feedModule!.posts![index].content = edit;
      getFeed();
      // print(feedModule!.posts![index].content);
      emit(EditPostSuccessState());
    }).catchError((error) {
      //print(error.toString());
      emit(EditPostErrorState());
    });
  }

  ViewPostModule? postView;
  void viewPosts({required String id}) {
    emit(ViewPostLoadingState());
    DioHelper.getData(url: '$posts$id', token: token).then((value) {
      postView = ViewPostModule.fromJson(value.data);
      emit(ViewPostSuccessState());
    }).catchError((error) {
      emit(ViewPostErrorState());
    });
  }

  void likePost({required String id, required int index}) {
    emit(AddLikePostLoadingState());
    if (!isLikePost![index]) {
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

  //change color icon likes posts
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

  //Add Image to Post
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
    DioHelper.postFormData(url: addPost, token: token, data: formData)
        .then((value) {
      emit(AddNewPostSuccessState());
    }).catchError((error) {
      emit(AddNewPostErrorState());
    });
  }

  void deletePost({required String id}){
    emit(PostDeleteLoadingState());
     DioHelper.deleteData(url: '$posts$id',token: token).then((value) {
      getFeed();
      emit(PostDeleteSuccessState());
    }).catchError((error){
      emit(PostDeleteErrorState());
    });
  }

  void deletePhotoPost() {
    postImage = null;
    emit(DeletePhotoPostState());
  }

  LikesModule? getLikes;
  Future<void> getLikesPost({required String id}) async {
    emit(GetLikePostLoadingState());
    return await DioHelper.getData(
            url: '$posts$id$likePost_2', token: token)
        .then((value) {
      getLikes = LikesModule.fromJson(value.data);
      emit(GetLikePostSuccessState());
    }).catchError((error) {
      emit(GetLikePostErrorState());
    });
  }

  CommentsModule? comment;
  List<bool>? isLikeComment = [];
  List<int>? likeCommentCount = [];
  void getComments({required String id}) {
    emit(GetCommentPostLoadingState());
     DioHelper.getData(url: '$comments_1$id$comments_2', token: token)
        .then((value) {
      comment = CommentsModule.fromJson(value.data);
      for (var element in comment!.comments!) {
        isLikeComment!.add(element.likedByUser!);
        likeCommentCount!.add(element.likesCount!);
      }
      emit(GetCommentPostSuccessState());
    }).catchError((error) {
      emit(GetCommentPostErrorState());
    });
  }

  void likeComment(
      {required String idPost, required String idComment, required int index}) {
    emit(LikeCommentPostLoadingState());
    if (!isLikeComment![index]) {
      DioHelper.postData(
              url: '$comments_1$idPost$comments_2/$idComment$likePost_2',
              token: token)
          .then((value) {
        emit(AddLikeCommentPostSuccessState());
      }).catchError((error) {
        emit(AddLikeCommentPostErrorState());
      });
    } else {
      DioHelper.deleteData(
              url: '$comments_1$idPost$comments_2/$idComment$likePost_2',
              token: token)
          .then((value) {
            emit(DeleteLikeCommentPostSuccessState());
      })
          .catchError((error) {
            emit(DeleteLikeCommentPostErrorState());
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
  
  void deleteComment({required String postId,required String commentId}){
    emit(DeleteCommentPostLoadingState());
    DioHelper.deleteData(url: '$comments_1$postId$comments_2/$commentId',token: token).then((value) {
      getComments(id: postId);
      emit(DeleteCommentPostSuccessState());
    }).catchError((error){
      emit(DeleteCommentPostErrorState());
    });
  }

  void addComment({required String postId,required String text}){
    emit(AddCommentPostLoadingState());
    DioHelper.postData(url: '$comments_1$postId$comments_2',token: token,data: {
      'content':text
    }).then((value) {
      getComments(id: postId);
      emit(AddCommentPostSuccessState());
    }).catchError((error){
      emit(AddCommentPostErrorState());
    });
  }
  
  Future<void> editComment({required String postId,required String commentId,required String text})async{
    emit(EditCommentPostLoadingState());
    return await DioHelper.patchData(url: '$comments_1$postId$comments_2/$commentId', data: {
      'content':text
    },token: token).then((value) {
      getComments(id: postId);
      emit(EditCommentPostSuccessState());
    }).catchError((error){
      emit(EditCommentPostErrorState());
    });
  }

  UserPostsModule? userPost;
  List<bool>? isLikeUserPost=[];
  List<int>? likesUserCount=[];
  Future<void> getUserPosts({required String userId})async{
    emit(GetUserPostLoadingState());
    return await DioHelper.getData(url: '$users$userId$userPosts',token: token).then((value) {
      userPost=UserPostsModule.fromJson(value.data);
      for (var element in userPost!.posts!) {
        isLikeUserPost!.add(element.likedByUser!);
        likesUserCount!.add(element.likesCount!);
      }
      emit(GetUserPostSuccessState());
    }).catchError((error){
      emit(GetUserPostErrorState());
    });
  }

  void likeUserPost({required String id, required int index}) {
    emit(AddLikeUserPostLoadingState());
    if (!isLikeUserPost![index]) {
      DioHelper.postData(url: '$posts$id$likePost_2', token: token)
          .then((value) {
        emit(AddLikeUserPostSuccessState());
      }).catchError((error) {
        emit(AddLikeUserPostErrorState());
      });
    } else {
      DioHelper.deleteData(url: '$posts$id$likePost_2', token: token)
          .then((value) {
        emit(DeleteLikeUserPostSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(DeleteLikeUserPostErrorState());
      });
    }
  }

  void editUserPosts({required String edit, required String id, required int index}) {
    emit(EditUserPostLoadingState());
    DioHelper.patchData(
        url: '$posts$id', data: {'content': edit}, token: token)
        .then((value) {
      userPost!.posts![index].content = edit;
      getUserPosts(userId: userId!);
      // print(feedModule!.posts![index].content);
      emit(EditUserPostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(EditUserPostErrorState());
    });
  }

  UserProfileModule? userProfile;
  void getUserProfile({required String id}){
    emit(GetUserProfileLoadingState());
    DioHelper.getData(url: '$users$id',token: token).then((value) {
      userProfile=UserProfileModule.fromJson(value.data);
      print(userProfile!.user!.imageFull!.data!.type);
      emit(GetUserProfileSuccessState());
    }).catchError((error){
      emit(GetUserProfileErrorState());
    });
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

  UserCommentsModule? userComments;
  void getUserComments({required String id}){
    emit(GetUserCommentsLoadingState());
    DioHelper.getData(url: '$users$id$comments_2',token: token).then((value) {
      userComments=UserCommentsModule.fromJson(value.data);
      for (var element in userComments!.comments!) {
        isLikeComment!.add(element.likedByUser!);
        likeCommentCount!.add(element.likesCount!);
      }
      emit(GetUserCommentsSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(GetUserCommentsErrorState());
    });
  }

  UserFriendsModule? userFriends;
  void getUSerFriends({required String id}){
    emit(GetUserFriendsLoadingState());
    DioHelper.getData(url: '$users$id$friends',token: token).then((value) {
      userFriends=UserFriendsModule.fromJson(value.data);
      emit(GetUserFriendsSuccessState());
    }).catchError((error){
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

  void editUserProfile({required String id,required String firstName,required String lastName}){
    emit(UpdateUserProfileLoadingState());
    FormData formData = FormData.fromMap({
      "firstName": firstName,
      "lastName": lastName,
      "profilePicture":
      profileImage != null ? MultipartFile.fromFileSync(profileImage!.path) : null
    });
    DioHelper.patchFormData(url: '$users$id', data: formData,token: token).then((value) {
      getUserProfile(id: id);
      print(value.statusMessage);
      emit(UpdateUserProfileSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(UpdateUserProfileErrorState());
    });
  }

  Future<void> sendRequestFriend({required String id})async{
    emit(SendRequestLoadingState());
    return await DioHelper.postData(url: '$users$id$friendRequests',token: token).then((value) {
      emit(SendRequestSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SendRequestErrorState());
    });
  }

  Future<void> cancelSendRequestFriend({required String receiveId})async{
    emit(CancelSendRequestLoadingState());
    return await DioHelper.deleteData(url: '$users$userId$cancelFriendRequests$receiveId',token: token).then((value) {
      emit(CancelSendRequestSuccessState());
    }).catchError((error){
      emit(CancelSendRequestErrorState());
    });
  }

  Future<void> cancelFriend({required String receiveId})async{
    emit(CancelFriendLoadingState());
    return await DioHelper.deleteData(url: '$users$userId$cancelFriends$receiveId',token: token).then((value) {
      emit(CancelFriendSuccessState());
    }).catchError((error){
      emit(CancelFriendErrorState());
    });
  }

  void deleteUser(){
    emit(DeleteUserLoadingState());
    DioHelper.deleteData(url: '$users$userId',token: token).then((value) {
      emit(DeleteUserSuccessState());
    }).catchError((error){emit(DeleteUserErrorState());
    });
  }

  FriendsRequestModule? friendRequest;
  void getFriendRequest(){
    emit(GetFriendsRequestLoadingState());
    DioHelper.getData(url: '$users$userId$friendRequests',token: token).then((value) {
      friendRequest=FriendsRequestModule.fromJson(value.data);
      emit(GetFriendsRequestSuccessState());
    }).catchError((error){
      emit(GetFriendsRequestErrorState());
    });
  }

  FriendRecommendationModule? friendsRecommendation;
  void getFriendRecommendation(){
    emit(GetFriendRecommendationLoadingState());
    DioHelper.getData(url: '$users$userId$friendRecommendation',token: token).then((value){
      friendsRecommendation=FriendRecommendationModule.fromJson(value.data);
      emit(GetFriendRecommendationSuccessState());
    }).catchError((error){
      emit(GetFriendRecommendationErrorState());
    });
  }

  void acceptFriendRequest({required String id}){
    emit(AcceptFriendRequestLoadingState());
    DioHelper.postData(url: '$users$userId$cancelFriends$id',token: token).then((value) {
      getFriendRequest();
      getFriendRecommendation();
      emit(AcceptFriendRequestSuccessState());
    }).catchError((error){
      emit(AcceptFriendRequestErrorState());
    });
  }
}


