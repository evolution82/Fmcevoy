require 'pry'
class LenghtCalculator < Struct.new(:array)
   def calculate
       @listsize = 0
       array.each do |var|
           if var == -1
               next 
           end
           @listsize +=  1
       end
       @listsize
   end
end
binding.pry
