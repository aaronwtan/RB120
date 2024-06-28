# Create a class 'Student' with attributes name and grade.
# Do NOT make the grade getter public, so joe.grade will raise an error.
# Create a better_grade_than? method, that you can call like so...
# puts "Well done!" if joe.better_grade_than?(bob)

class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  attr_reader :grade
end

joe = Student.new('Joe', 99)
bob = Student.new('Bob', 50)

puts "Well done, #{joe.name}!" if joe.better_grade_than?(bob)
puts "Well done, #{bob.name}!" if bob.better_grade_than?(joe)

bob.grade = 100

puts "Well done, #{joe.name}!" if joe.better_grade_than?(bob)
puts "Well done, #{bob.name}!" if bob.better_grade_than?(joe)
