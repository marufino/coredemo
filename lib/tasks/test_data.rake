namespace :app do

  # Checks and ensures task is not run in production.
  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "\nI'm sorry, I can't do that.\n(You're asking me to drop your production database.)"
    end
  end

  # Custom install for developement environment
  desc "Install"
  task :install => [:ensure_development_environment, "db:migrate", "db:test:prepare", "db:seed", "app:populate", "spec"]

  # Custom reset for developement environment
  desc "Reset"
  task :reset => [:ensure_development_environment, "db:drop", "db:create", "db:migrate", "db:test:prepare", "db:seed", "app:populate"]

  # Populates development data
  desc "Populate the database with development data."
  task :populate => :environment do
    # Removes content before populating with data to avoid duplication
    Rake::Task['db:reset'].invoke

    # INSERT BELOW

    u=[]
    t=[]
    o=[]
    p=[]
    a=[]
    s=[]
    r=[]
    score=[]

    n = 50

    n.times do |i|
      u[i] = Fabricate(:user)
      t[i] = Fabricate(:trainee)

      t[i].user = u[i]

      u[i] = Fabricate(:user)
      o[i] = Fabricate(:observer)

      o[i].user = u[i]

      s[i] = Fabricate(:survey)

      p[i] = Fabricate(:project)
    end

    #populate project


    p.each_with_index do |p,i|

      # assign random observers
      p.observers << o[rand(0..n-1)]

      # make assignments
      a[i] = Fabricate(:assignment)

      # add survey to assignment
      p_survey = s[rand(0..n-1)]
      a[i].surveys << p_survey
      a[i].survey_id = p_survey.id

      # assign trainees to assignment
      a[i].trainees << t[rand(0..n-1)]

      # generate scores for assignment -> trainee combos
      score[i] = Fabricate(:score)

      # add trainee to score
      score[i].trainee = a[i].trainees.first

      ### generate ratings
      a[i].surveys.first.survey_blocks.each do |block| block.questions.each_with_index do |q , j |

          # generate ratings
          r[j] = Fabricate(:rating)

          # belongs to question
          r[j].question = q

          # add to score
          score[i].ratings << r[j]

          # belongs to observers
          r[j].observer = p.observers.first

          r[j].save
          end
      end

      score[i].assignment_id = a[i].id

      # add assignment to project
      p.assignments << a[i]

      score[i].save
      a[i].save
      p.save


    end


    # INSERT ABOVE

  end

end