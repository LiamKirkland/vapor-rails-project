class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend_id])
    friendship = current_user.friendships.build(friend: friend)

    if friendship.save
      redirect_back fallback_location: root_path, notice: "Friend request sent"
    else
      redirect_back fallback_location: root_path, alert: friendship.errors.full_messages.to_sentence
    end
  end

  def accept
    friendship = current_user.inv_friendships.find(params[:id])
    friendship.update(status: "accepted")
    redirect_back fallback_location: root_path, notice: "Friend request accepted"
  end

  def destroy
    friendship = current_user.friendships.find_by(id: params[:id]) ||
                 current_user.inv_friendships.find_by(id: params[:id])
    friendship&.destroy
    redirect_back fallback_location: root_path, notice: "Removed from friendslist"
  end
end
