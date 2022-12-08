import 'package:dio/dio.dart';
import 'package:purplebook/modules/error_module.dart';
import 'package:purplebook/modules/feed_module.dart';

abstract class PurpleBookState {}

class InitialPurpleBookState extends PurpleBookState {}

class ChangeBottomState extends PurpleBookState {}

class ChangeThemeModeState extends PurpleBookState {}

class ChangeVisibilityState extends PurpleBookState {}

class ChangeColorIconState extends PurpleBookState {}

class ChangeLikeCommentState extends PurpleBookState {}

class GetFeedLoadingState extends PurpleBookState {}

class GetFeedSuccessState extends PurpleBookState {
  final FeedModule feed;
  GetFeedSuccessState(this.feed);
}

class GetFeedErrorState extends PurpleBookState {}

class GetMoreFeedLoadingState extends PurpleBookState {}

class GetMoreFeedSuccessState extends PurpleBookState {}

class GetMoreFeedErrorState extends PurpleBookState {}

class FeedAfterDeleteLoadingState extends PurpleBookState {}

class FeedAfterDeleteSuccessState extends PurpleBookState {}

class FeedAfterDeleteErrorState extends PurpleBookState {}

class EditPostLoadingState extends PurpleBookState {}

class EditPostSuccessState extends PurpleBookState {}

class EditPostErrorState extends PurpleBookState {
  final DioError error;

  EditPostErrorState(this.error);
}

class ViewPostLoadingState extends PurpleBookState {}

class ViewPostSuccessState extends PurpleBookState {}

class ViewPostErrorState extends PurpleBookState {}

class ViewSingleCommentLoadingState extends PurpleBookState {}

class ViewSingleCommentSuccessState extends PurpleBookState {}

class ViewSingleCommentErrorState extends PurpleBookState {}

class ChangeLikeSingleCommentState extends PurpleBookState {}

class AddLikeSinglePostLoadingState extends PurpleBookState {}

class AddLikeSinglePostSuccessState extends PurpleBookState {}

class AddLikeSinglePostErrorState extends PurpleBookState {}

class DeleteLikeSinglePostSuccessState extends PurpleBookState {}

class DeleteLikeSinglePostErrorState extends PurpleBookState {}

class AddLikePostLoadingState extends PurpleBookState {}

class AddLikePostSuccessState extends PurpleBookState {}

class AddLikePostErrorState extends PurpleBookState {}

class DeleteLikePostSuccessState extends PurpleBookState {}

class DeleteLikePostErrorState extends PurpleBookState {}

class ChangeLikePostState extends PurpleBookState {}

class GetPostImageSuccessState extends PurpleBookState {}

class GetPostImageErrorState extends PurpleBookState {}

class GetProfileImageSuccessState extends PurpleBookState {}

class GetProfileImageErrorState extends PurpleBookState {}

class AddNewPostLoadingState extends PurpleBookState {}

class AddNewPostSuccessState extends PurpleBookState {}

class AddNewPostErrorState extends PurpleBookState {
  final ErrorModule error;

  AddNewPostErrorState(this.error);
}

class PostDeleteLoadingState extends PurpleBookState {}

class PostDeleteSuccessState extends PurpleBookState {}

class PostDeleteErrorState extends PurpleBookState {
  final DioError error;

  PostDeleteErrorState(this.error);
}

class DeletePhotoPostState extends PurpleBookState {}

class DeletePhotoProfileState extends PurpleBookState {}

class GetLikePostLoadingState extends PurpleBookState {}

class GetLikePostSuccessState extends PurpleBookState {}

class GetLikePostErrorState extends PurpleBookState {}

class GetCommentPostLoadingState extends PurpleBookState {}

class GetCommentPostSuccessState extends PurpleBookState {}

class GetCommentPostErrorState extends PurpleBookState {}

class GetMoreCommentPostLoadingState extends PurpleBookState {}

class GetMoreCommentPostSuccessState extends PurpleBookState {}

class GetMoreCommentPostErrorState extends PurpleBookState {}

class GetLikeCommentsLoadingState extends PurpleBookState {}

class GetLikeCommentsSuccessState extends PurpleBookState {}

class GetLikeCommentsErrorState extends PurpleBookState {}

class LikeCommentPostLoadingState extends PurpleBookState {}

class AddLikeCommentPostSuccessState extends PurpleBookState {}

class AddLikeCommentPostErrorState extends PurpleBookState {
  final DioError error;

  AddLikeCommentPostErrorState(this.error);
}

class DeleteLikeCommentPostSuccessState extends PurpleBookState {}

class DeleteLikeCommentPostErrorState extends PurpleBookState {
  final DioError error;

  DeleteLikeCommentPostErrorState(this.error);
}
class LikeSingleCommentPostLoadingState extends PurpleBookState {}

class AddLikeSingleCommentPostSuccessState extends PurpleBookState {}

class AddLikeSingleCommentPostErrorState extends PurpleBookState {
  final DioError error;

  AddLikeSingleCommentPostErrorState(this.error);
}

class DeleteLikeSingleCommentPostSuccessState extends PurpleBookState {}

class DeleteLikeSingleCommentPostErrorState extends PurpleBookState {
  final DioError error;

  DeleteLikeSingleCommentPostErrorState(this.error);
}

class DeleteCommentPostLoadingState extends PurpleBookState {}

class DeleteCommentPostSuccessState extends PurpleBookState {}

class DeleteCommentPostErrorState extends PurpleBookState {
  final DioError error;

  DeleteCommentPostErrorState(this.error);
}

class AddCommentPostLoadingState extends PurpleBookState {}

class AddCommentPostSuccessState extends PurpleBookState {}

class AddCommentPostErrorState extends PurpleBookState {
  final DioError error;

  AddCommentPostErrorState(this.error);
}

class EditCommentPostLoadingState extends PurpleBookState {}

class EditCommentPostSuccessState extends PurpleBookState {}

class EditCommentPostErrorState extends PurpleBookState {}

class GetUserPostLoadingState extends PurpleBookState {}

class GetUserPostSuccessState extends PurpleBookState {}

class GetUserPostErrorState extends PurpleBookState {}

class GetMoreUserPostLoadingState extends PurpleBookState {}

class GetMoreUserPostSuccessState extends PurpleBookState {}

class GetMoreUserPostErrorState extends PurpleBookState {}

class EditUserPostLoadingState extends PurpleBookState {}

class EditUserPostSuccessState extends PurpleBookState {}

class EditUserPostErrorState extends PurpleBookState {}

class GetUserProfileLoadingState extends PurpleBookState {}

class GetUserProfileSuccessState extends PurpleBookState {}

class GetUserProfileErrorState extends PurpleBookState {}

class AddLikeUserPostLoadingState extends PurpleBookState {}

class AddLikeUserPostSuccessState extends PurpleBookState {}

class AddLikeUserPostErrorState extends PurpleBookState {
  final DioError error;

  AddLikeUserPostErrorState(this.error);
}

class DeleteLikeUserPostSuccessState extends PurpleBookState {}

class DeleteLikeUserPostErrorState extends PurpleBookState {
  final DioError error;

  DeleteLikeUserPostErrorState(this.error);
}

class ChangeColorUSerLikeState extends PurpleBookState {}

class GetUserCommentsLoadingState extends PurpleBookState {}

class GetUserCommentsSuccessState extends PurpleBookState {}

class GetUserCommentsErrorState extends PurpleBookState {}

class DropDownCallBackState extends PurpleBookState {}

class GetMoreUserCommentsLoadingState extends PurpleBookState {}

class GetMoreUserCommentsSuccessState extends PurpleBookState {}

class GetMoreUserCommentsErrorState extends PurpleBookState {}

class GetUserFriendsLoadingState extends PurpleBookState {}

class GetUserFriendsSuccessState extends PurpleBookState {}

class GetUserFriendsErrorState extends PurpleBookState {}

class UpdateUserProfileLoadingState extends PurpleBookState {}

class UpdateUserProfileSuccessState extends PurpleBookState {}

class UpdateUserProfileErrorState extends PurpleBookState {
  final ErrorModule error;

  UpdateUserProfileErrorState(this.error);
}

class SendFriendRequestLoadingState extends PurpleBookState {}

class SendFriendRequestSuccessState extends PurpleBookState {}

class SendFriendRequestErrorState extends PurpleBookState {
  final DioError error;

  SendFriendRequestErrorState(this.error);
}

class CancelSendFriendRequestLoadingState extends PurpleBookState {}

class CancelSendFriendRequestSuccessState extends PurpleBookState {}

class CancelSendFriendRequestErrorState extends PurpleBookState {
  final DioError error;

  CancelSendFriendRequestErrorState(this.error);
}

class CancelFriendLoadingState extends PurpleBookState {}

class CancelFriendSuccessState extends PurpleBookState {}

class CancelFriendErrorState extends PurpleBookState {
  final DioError error;

  CancelFriendErrorState(this.error);
}

class DeleteUserLoadingState extends PurpleBookState {}

class DeleteUserSuccessState extends PurpleBookState {}

class DeleteUserErrorState extends PurpleBookState {}

class GetFriendsRequestLoadingState extends PurpleBookState {}

class GetFriendsRequestSuccessState extends PurpleBookState {}

class GetFriendsRequestErrorState extends PurpleBookState {}

class GetFriendsRequestAllScreenLoadingState extends PurpleBookState {}

class GetFriendsRequestAllScreenSuccessState extends PurpleBookState {}

class GetFriendsRequestAllScreenErrorState extends PurpleBookState {}

class GetFriendRecommendationLoadingState extends PurpleBookState {}

class GetFriendRecommendationSuccessState extends PurpleBookState {}

class GetFriendRecommendationErrorState extends PurpleBookState {}

class AcceptFriendRequestLoadingState extends PurpleBookState {}

class AcceptFriendRequestSuccessState extends PurpleBookState {}

class AcceptFriendRequestErrorState extends PurpleBookState {
  final DioError error;

  AcceptFriendRequestErrorState(this.error);
}

class RemoveFriendRequestLoadingState extends PurpleBookState {}

class RemoveFriendRequestSuccessState extends PurpleBookState {}

class RemoveFriendRequestErrorState extends PurpleBookState {}

class ViewedFriendRequestLoadingState extends PurpleBookState {}

class ViewedFriendRequestSuccessState extends PurpleBookState {}

class ViewedFriendRequestErrorState extends PurpleBookState {}

class ViewedAllNotificationsLoadingState extends PurpleBookState {}

class ViewedAllNotificationsSuccessState extends PurpleBookState {}

class ViewedAllNotificationsErrorState extends PurpleBookState {}

class GetNotificationsLoadingState extends PurpleBookState {}

class GetNotificationsSuccessState extends PurpleBookState {}

class GetNotificationsErrorState extends PurpleBookState {}

class GetMoreNotificationsLoadingState extends PurpleBookState {}

class GetMoreNotificationsSuccessState extends PurpleBookState {}

class GetMoreNotificationsErrorState extends PurpleBookState {}

class GetNotifyFromAnyScreenLoadingState extends PurpleBookState {}

class GetNotifyFromAnyScreenSuccessState extends PurpleBookState {}

class GetNotifyFromAnyScreenErrorState extends PurpleBookState {}
