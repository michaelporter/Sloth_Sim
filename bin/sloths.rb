#!/usr/bin/ruby -w

require 'lib/Sanctuary.rb'

sanctuary = ["###################", 
             "# ** *****  **    #", 
             "#    @ *    *  *  #", 
             "#**   *** *   @** #", 
             "#  * *** @ *   *  #", 
             "# **     ****   * #", 
             "# * @  **** *  *  #", 
             "###################"]

sanc = Sanctuary.new(sanctuary)

sanc.first_pass
sanc.print_sanc

loop do
  sanc.step
  sanc.print_sanc
  sleep(5)
end



