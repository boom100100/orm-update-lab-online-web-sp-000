require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"

    DB[:conn].execute(sql)
  end

  def save
    if @id

      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
      DB[:conn].execute(sql, self.name, self.grade, self.id)

    else

      sql = "INSERT INTO students(name, grade) VALUES(?, ?);"
      DB[:conn].execute(sql, self.name, self.grade)

      last = "SELECT last_insert_rowid() FROM students"
      row = DB[:conn].execute(last)
      @id = row[0][0]

    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])

  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?;"
    row = DB[:conn].execute(sql, name)[0]

    student = Student.new(row[1], row[2], row[0])

  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  #  with DB[:conn]


end
