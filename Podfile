
Recently, I encountered the same problem. No Podfile created even when I add dependency packages in the pubspec.yaml file. In the end, I have to manually add a Pod file in the ios directory and issue 'pod deintegrate', 'pod setup' and 'pod install'.

Here is my podfile. You can try it:

# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

pod 'Firebase/Core'
pod 'FBSDKLoginKit' #optional
pod 'GoogleAnalytics'

def parse_KV_file(file, separator='=')
  file_abs_path = File.expand_path(file)
  if !File.exists? file_abs_path
    return [];
  end
  pods_ary = []
  skip_line_start_symbols = ["#", "/"]
  File.foreach(file_abs_path) { |line|
      next if skip_line_start_symbols.any? { |symbol| line =~ /^\s*#{symbol}/ }
      plugin = line.split(pattern=separator)
      if plugin.length == 2
        podname = plugin[0].strip()
        path = plugin[1].strip()
        podpath = File.expand_path("#{path}", file_abs_path)
        pods_ary.push({:name => podname, :path => podpath});
      else
        puts "Invalid plugin specification: #{line}"
      end
  }
  return pods_ary
end

target 'Runner' do
  # Prepare symlinks folder. We use symlinks to avoid having Podfile.lock
  # referring to absolute paths on developers' machines.
  use_frameworks! 
  system('rm -rf .symlinks')
  system('mkdir -p .symlinks/plugins')

  # Flutter Pods
  generated_xcode_build_settings = parse_KV_file('./Flutter/Generated.xcconfig')
  if generated_xcode_build_settings.empty?
    puts "Generated.xcconfig must exist. If you're running pod install manually, make sure flutter packages get is executed first."
  end
  generated_xcode_build_settings.map { |p|
    if p[:name] == 'FLUTTER_FRAMEWORK_DIR'
      symlink = File.join('.symlinks', 'flutter')
      File.symlink(File.dirname(p[:path]), symlink)
      pod 'Flutter', :path => File.join(symlink, File.basename(p[:path]))
    end
  }

  # Plugin Pods
  plugin_pods = parse_KV_file('../.flutter-plugins')
  plugin_pods.map { |p|
    symlink = File.join('.symlinks', 'plugins', p[:name])
    File.symlink(p[:path], symlink)
    pod p[:name], :path => File.join(symlink, 'ios')
  }
end


#pre_install do |installer|
  # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
 # Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
#end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end

    # Peter aded on 8 Oct 2018
    # workaround for https://github.com/CocoaPods/CocoaPods/issues/7463
    #target.headers_build_phase.files.each do |file|
     # file.settings = { 'ATTRIBUTES' => ['Public'] }
    #end

  end
end
