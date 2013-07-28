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
      sub_tags << content_tag('span', :class => 'ml-5') { text(wish.status) }
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
      link_to "#{user_path(wish.wishers.current.user_id)}", opts do
        yield
      end
    end
  end
end
