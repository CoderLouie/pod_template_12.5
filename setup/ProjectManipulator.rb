require 'xcodeproj'

module Pod
    
    class ProjectManipulator
        attr_reader :configurator, :xcodeproj_path, :platform, :remove_demo_target, :string_replacements, :prefix
        
        def self.perform(options)
            new(options).perform
        end
        
        def initialize(options)
            @xcodeproj_path = options.fetch(:xcodeproj_path)
            @configurator = options.fetch(:configurator)
            @platform = options.fetch(:platform)
            @remove_demo_target = options.fetch(:remove_demo_project)
            @prefix = options.fetch(:prefix)
        end
        
        def run
            @string_replacements = {
                "PROJECT_OWNER" => @configurator.project_owner,
                "USER_NAME" => @configurator.user_name,
                "TODAYS_DATE" => @configurator.date,
                "TODAYS_YEAR" =>  @configurator.year,
                "PROJECT" => @configurator.pod_name,
                "CPD" => @prefix
            }
            replace_internal_project_settings
            
            @project = Xcodeproj::Project.open(@xcodeproj_path)
            @project.save
            
            rename_files
            rename_project_folder
        end
        
        def project_folder
            File.dirname @xcodeproj_path
        end
        
        def rename_files
            # shared schemes have project specific names
            scheme_path = project_folder + "/PROJECT.xcodeproj/xcshareddata/xcschemes/"
            File.rename(scheme_path + "PROJECT_dev.xcscheme", scheme_path +  @configurator.pod_name + "_dev.xcscheme")
            File.rename(scheme_path + "PROJECT_dis.xcscheme", scheme_path +  @configurator.pod_name + "_dis.xcscheme")
            
            # rename xcproject
            File.rename(project_folder + "/PROJECT.xcodeproj", project_folder + "/" +  @configurator.pod_name + ".xcodeproj")
            
            before = project_folder + "/PROJECT/Other/PROJECT-Bridging-Header.h"
            if File.exists? before
                after = project_folder + "/PROJECT/Other/" +  @configurator.pod_name + "-Bridging-Header.h"
                File.rename before, after
            end
            
            before = project_folder + "/PROJECT/Other/PROJECT-Prefix.pch"
            if File.exists? before
                after = project_folder + "/PROJECT/Other/" +  @configurator.pod_name + "-Prefix.pch"
                File.rename before, after
            end
            
            ["CPDAppDelegate.h", "CPDAppDelegate.m"].each do |file|
                before = project_folder + "/PROJECT/" + file
                next unless File.exists? before
                
                after = project_folder + "/PROJECT/" + file.gsub("CPD", prefix)
                File.rename before, after
            end
            
            ["CPDHomeViewController.h", "CPDHomeViewController.m"].each do |file|
                before = project_folder + "/PROJECT/Modules/Home/" + file
                next unless File.exists? before
                
                after = project_folder + "/PROJECT/Modules/Home/" + file.gsub("CPD", prefix)
                File.rename before, after
            end
            ["CPDProfileViewController.h", "CPDProfileViewController.m"].each do |file|
                before = project_folder + "/PROJECT/Modules/Profile/" + file
                next unless File.exists? before
                
                after = project_folder + "/PROJECT/Modules/Profile/" + file.gsub("CPD", prefix)
                File.rename before, after
            end
        end
        
        def rename_project_folder
            if Dir.exist? project_folder + "/PROJECT"
                File.rename(project_folder + "/PROJECT", project_folder + "/" + @configurator.pod_name)
            end
        end
        
        def replace_internal_project_settings
            Dir.glob(project_folder + "/**/**/**/**").each do |name|
                next if Dir.exists? name
                text = File.read(name)
                
                for find, replace in @string_replacements
                    text = text.gsub(find, replace)
                end
                
                File.open(name, "w") { |file| file.puts text }
            end
        end
        
    end
    
end
