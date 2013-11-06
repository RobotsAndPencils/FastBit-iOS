Pod::Spec.new do |s|
  s.name = 'FastBit'
  s.version = '0.0.1'
  s.platform = :ios
  s.summary = 'FastBit library for iOS.'
  s.description = 'FastBit data processing library compiled for iOS.'
  s.homepage = 'https://github.com/RobotsAndPencils/FastBit-iOS'
  s.author = 'Michael Beauregard'
  s.source = { 
    :git => 'git@github.com:RobotsAndPencils/FastBit-iOS.git'
    }
  s.license = {
    :type => 'LGPL',
    :text => <<-LICENSE
    http://crd-legacy.lbl.gov/~kewu/fastbit/src/license.txt
    LICENSE
  }
  
  s.platform = :ios
  s.source_files = 'include/*.h'
  s.preserve_paths = 'lib/libFastBit.a'
  s.library = 'FastBit'
  s.xcconfig  =  { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/FastBit/lib"', 'OTHER_LDFLAGS' => '-lstdc++' }
end
