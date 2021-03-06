module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def notice1
    render 'layouts/noticep' if notice.present?
  end

  def alert1
    render 'layouts/alertp' if alert.present?
  end

  def devisemap(variable)
    render partial: 'layouts/devise', locals: { variable1: variable } if devise_mapping.rememberable?
  end

  def current_user1
    if current_user
      render 'layouts/currentpartial'
    else
      render 'layouts/noncurrentpartial'
    end
  end

  def checkfriend1(user, show = nil)
    return 'Yourself' if (current_user.id == user.id) and show == 'show'
    return if (current_user.id == user.id) and show.nil?

    checkfriend(user)
  end

  def checkfriend(user)
    friendobject = Friendship.new

    if friendobject.await(current_user, user)
      render partial: 'friendships/awaiting'
    elsif friendobject.friendss(current_user, user)
      render partial: 'friendships/friends'
    else
      render partial: 'friendships/onshowrequest', locals: { user: user }
    end
  end

  def checkusercurrent
    return unless current_user

    friendobject = Friendship.new
    count = friendobject.pendingreq(current_user) if current_user
    if count.count.positive?
      render partial: 'layouts/showinnavbut', locals: { count: count }
    else
      render partial: 'layouts/showinnav'
    end
  end
end
