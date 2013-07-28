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

  def wish_status_tag(wish)
    case wish.status
    when "PENDING"
      content_tag 'span', :class => 'label label-block' do
        sub_tags = []
        sub_tags << content_tag('i', nil, :class => "icon-flag-alt")
        sub_tags << content_tag('span', :class => 'ml-5') do
          "等待认领"
        end
        sub_tags.join.html_safe
      end
    when "LOCKED"
      content_tag 'span', :class => 'label label-warning label-block' do
        sub_tags = []
        sub_tags << content_tag('i', nil, :class => "icon-flag")
        sub_tags << content_tag('span', :class => 'ml-5') do
          "已被认领尚未完成"
        end
        sub_tags.join.html_safe
      end
    when "GRANTED"
      content_tag 'span', :class => 'label label-success label-block' do
        sub_tags = []
        sub_tags << content_tag('i', nil, :class => "icon-ok-sign")
        sub_tags << content_tag('span', :class => 'ml-5') do
          "愿望达成"
        end
        sub_tags.join.html_safe
      end
    when "FAILED"
      content_tag 'span', :class => 'label label-important label-block' do
        sub_tags = []
        sub_tags << content_tag('i', nil, :class => "icon-remove-sign")
        sub_tags << content_tag('span', :class => 'ml-5') do
          "愿望失败"
        end
        sub_tags.join.html_safe
      end                  
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
