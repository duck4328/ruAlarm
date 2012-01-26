#!/usr/bin/ruby
require 'rubygems'
require 'fox16'
require 'fox16/colors'
include Fox

$timeToRing = ""
$alarmStatus = false

def TheGUI
application = FXApp.new("Alarm clock", "Alarm clock")
main = FXMainWindow.new(application, "Alarm clock", nil, nil, DECOR_ALL, 0,0, :width => 0, :height => 0)
contents = FXHorizontalFrame.new(main,LAYOUT_SIDE_LEFT|FRAME_NONE|LAYOUT_FILL_X|LAYOUT_FILL_Y|PACK_UNIFORM_WIDTH,:padding => 150)


aToggle = FXButton.new(contents, "&Turn on!", nil, main, :x => 200, :y => 200)
aTextbox = FXTextField.new(contents, 1) 
aTextbox.text ="Ring"
aTextbox.selBackColor = FXColor::Red
$timeToRing = aTextbox.text


aTextbox.connect(SEL_CHANGED) { |sender,sel, ptr| $timeToRing = aTextbox.text}


aToggle.connect(SEL_COMMAND) { |sender, sel, ptr| 
t = Time.now
x = t.strftime("%R")

if aToggle.text.eql?("Turn on!")
    $alarmStatus = true
    aToggle.text = "Turn off!"
    aTextbox.editable = true
else
    t3 = Thread.new {;}
    t3.kill
    $alarmStatus = false
    aToggle.text = "Turn on!"    
    aTextbox.editable = false
end
puts x
}

FXTextField.new(main, 10, nil)
application.create()
main.show(PLACEMENT_SCREEN)
application.run()
end


def timeCheck(anotherThread)
t3= Thread.new {;}
t2= Thread.new {;}    
   while anotherThread.alive?
      formattedTime = Time.now.strftime("%R")
      puts "Current time is: #{formattedTime}"
      if $timeToRing.eql?(formattedTime) and $alarmStatus 
          if (not t3.alive?)
          t3 = Thread.new{RingAlarm()}
          end
      end
      sleep(1)   
   end
end

def RingAlarm
    if  RUBY_PLATFORM.downcase.include?("darwin")
        `afplay alarm.mp3`
    else
        if RUBY_PLATFORM.downcase.include?("linux")
            `mpg123 alarm.mp3`
        end
    end
end


t2=Thread.new{TheGUI()}
t1=Thread.new{|thread| timeCheck(t2)}
t1.join
t2.join

