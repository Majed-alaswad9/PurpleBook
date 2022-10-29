import 'package:purplebook/modules/feed_moduel.dart';

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

class EditPostErrorState extends PurpleBookState {}

class ViewPostLoadingState extends PurpleBookState {}

class ViewPostSuccessState extends PurpleBookState {}

class ViewPostErrorState extends PurpleBookState {}

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

class ChangeLikePostState extends PurpleBookState{}

class GetPostImageSuccessState extends PurpleBookState {}

class GetPostImageErrorState extends PurpleBookState {}

class GetProfileImageSuccessState extends PurpleBookState {}

class GetProfileImageErrorState extends PurpleBookState {}

class AddNewPostLoadingState extends PurpleBookState {}

class AddNewPostSuccessState extends PurpleBookState {}

class AddNewPostErrorState extends PurpleBookState {}

class PostDeleteLoadingState extends PurpleBookState {}

class PostDeleteSuccessState extends PurpleBookState {}

class PostDeleteErrorState extends PurpleBookState {}

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

class AddLikeCommentPostErrorState extends PurpleBookState {}

class DeleteLikeCommentPostSuccessState extends PurpleBookState {}

class DeleteLikeCommentPostErrorState extends PurpleBookState {}

class DeleteCommentPostLoadingState extends PurpleBookState {}

class DeleteCommentPostSuccessState extends PurpleBookState {}

class DeleteCommentPostErrorState extends PurpleBookState {}

class AddCommentPostLoadingState extends PurpleBookState {}

class AddCommentPostSuccessState extends PurpleBookState {}

class AddCommentPostErrorState extends PurpleBookState {}

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

class AddLikeUserPostErrorState extends PurpleBookState {}

class DeleteLikeUserPostSuccessState extends PurpleBookState {}

class DeleteLikeUserPostErrorState extends PurpleBookState {}

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

class UpdateUserProfileErrorState extends PurpleBookState {}

class SendRequestLoadingState extends PurpleBookState {}

class SendRequestSuccessState extends PurpleBookState {}

class SendRequestErrorState extends PurpleBookState {}

class CancelSendRequestLoadingState extends PurpleBookState {}

class CancelSendRequestSuccessState extends PurpleBookState {}

class CancelSendRequestErrorState extends PurpleBookState {}

class CancelFriendLoadingState extends PurpleBookState {}

class CancelFriendSuccessState extends PurpleBookState {}

class CancelFriendErrorState extends PurpleBookState {}

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

class AcceptFriendRequestErrorState extends PurpleBookState {}

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

class GetNotifFromAnyScreenLoadingState extends PurpleBookState {}

class GetNotifFromAnyScreenSuccessState extends PurpleBookState {}

class GetNotifFromAnyScreenErrorState extends PurpleBookState {}
