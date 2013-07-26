module QnUploader
  extend ActiveSupport::Concern

  module ClassMethods
    def mount_uploader(column)
      mod = Module.new
      include mod

      mod.class_eval <<-RUBY, __FILE__, __LINE__+1

        def #{column}
          super
        end

        def #{column}=(new_file)
          file_path = case new_file.class.to_s
            when "ActionDispatch::Http::UploadedFile"
              new_file.tempfile.path
            when "Tempfile"
              new_file.path
            when "String"
              if File.exists?(new_file)
                new_file
              elsif new_file.start_with?('http://') || new_file.start_with?('https://')
                convert_to_tempfile(new_file).path
              else
                write_attribute(:#{column}, new_file)
                return new_file
              end
          end

          upload_token = Qiniu::RS.generate_upload_token({ scope: Setting.qiniu_bucket })          

          image = MiniMagick::Image.open(file_path)
          ext = image[:format].downcase
          timestamp = Time.now.to_i.to_s
          uuid = SecureRandom.hex(4)
          file_name = File.join "#{column}", timestamp, uuid
          upload_to_path = [file_name, ext].join(".")

          opts = {
            uptoken: upload_token,
            file: file_path,
            bucket: Setting.qiniu_bucket,
            mime_type: image.mime_type,
            key: upload_to_path        
          }

          Qiniu::RS.upload_file opts
          write_attribute(:#{column}, upload_to_path)
        end

        def #{column}_url(style = nil)
          file_path = read_attribute(:#{column})

          if file_path.blank?
            ret = if self.respond_to?("default_#{column}_url")
              File.join "/assets", self.send("default_#{column}_url", style)
            end
            return (ret || "")
          end

          file_url = File.join Setting.image_host, file_path
          if style
            [file_url, style.to_s].join("!")
          else
            file_url
          end
        end

        private

        def convert_to_tempfile(img_url)
          extname = File.extname(img_url)
          basename = File.basename(img_url, extname)
          file = Tempfile.new([basename, extname])
          file.binmode
          open(URI.parse(img_url)) do |data|  
            file.write data.read
          end
          file.rewind    
          file
        end

      RUBY
    end
  end

end