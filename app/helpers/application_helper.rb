# coding: utf-8
module ApplicationHelper
  
  def render_notice_message
    flash_messages = []

    flash.each do |type, message|
      text = content_tag(:div, link_to("x", "#", :class => "close", 'data-dismiss' => "alert") + message, :class => "alert alert-#{type}")
      flash_messages << text if message
    end

    flash_messages.join("\n").html_safe
  end

  def color(status)
    colors = {
      "PENDING"  => 'default',
      "LOCKED"   => 'warning',
      "GRANTED"  => 'success',
      "FAILED"   => 'important'
    }

    colors[status.upcase]
  end

  def icon(status)
    icons = {
      "PENDING"  => 'icon-flag-alt',
      "LOCKED"   => 'icon-flag',
      "GRANTED"  => 'icon-ok-sign',
      "FAILED"   => 'icon-remove-sign'
    }

    icons[status.upcase]
  end

  def text(status)
    texts = {
      "PENDING"  => '等待认领',
      "LOCKED"   => '已被认领尚未完成',
      "GRANTED"  => '愿望达成',
      "FAILED"   => '愿望失败'
    }

    texts[status.upcase]    
  end

  def wish_status_tag(wish)
    content_tag 'span', :class => "label label-#{color(wish.status)} label-block" do
      sub_tags = []
      sub_tags << content_tag('i', nil, :class => "#{icon(wish.status)}")
      sub_tags << content_tag('span', text(wish.status), :class => 'ml-5')
      sub_tags.join.html_safe
    end
  end

  def grant(wish, opts = {}, &block)
    if wish.pending?
      opts.merge!(method: "POST", confirm: "确认帮 #{wish.user.name} 完成愿望吗？")
      link_to grant_wish_path(wish), opts do
        yield
      end
    else
      link_to "#{user_path(wish.current_wisher.id)}", opts do
        yield
      end
    end
  end

  def render_notify_label
    unread_count = current_user.unread_notifies_count
    klass = "label"
    klass << " label-important" unless unread_count.zero?
    content_tag 'span', current_user.unread_notifies_count, :class => klass
  end

  def format_link(refer_link)
    link = refer_link[/^https?:\/\//] ? refer_link : "http://" + refer_link
  end

  def confirmable?(wish)
    wish.user == current_user && wish.locked?
  end

  def share_to_weibo(user)
    title = %Q(@#{user.name} 许了#{user.wishes_count}个愿望，来一起帮助TA实现吧！)
    pic = user.avatar_url
    url = user_url(user)
    %Q(http://service.weibo.com/share/share.php?&url=#{url}&title=#{title}&pic=#{pic})
  end  
end
