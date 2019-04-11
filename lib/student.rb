require 'pry'
require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute('CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)')
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE students')
  end

  def save
    if self.id == nil
      DB[:conn].execute('INSERT INTO students(name, grade) VALUES(?, ?)', self.name, self.grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
    else
      DB[:conn].execute('UPDATE students SET name = ? AND grade = ? WHERE id = ?', self.name, self.grade, self.id)
    end
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def self.new_from_db(row)
    new_student = Student.new(row[1], row[2])
    new_student.id = row[0]
    new_student
  end


  def self.find_by_name(name)
    DB[:conn].execute('SELECT * FROM students WHERE name = ? LIMIT 1', name)

    binding.pry
  end


  def update
    DB[:conn].execute('UPDATE students SET name = ? AND grade = ? WHERE id = ?', self.name, self.grade, self.id)
  end

end
