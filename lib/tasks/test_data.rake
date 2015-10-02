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

    30.times do
      competency = Fabricate(:competency)
      competency.save
    end

    n = 10

    n.times do |i|
      u[i] = Fabricate(:user)
      t[i] = Fabricate(:trainee)

      t[i].user = u[i]

      u[i] = Fabricate(:user)
      o[i] = Fabricate(:observer)

      o[i].user = u[i]

      s[i] = Fabricate(:survey)
      s[i].survey_blocks.each_with_index do |sb,i|
        sb.category = $categorynames[i]
      end
      s[i].save

      p[i] = Fabricate.build(:project)
    end



    #populate project

    p.each do |p|
      p.observers.each do |s|
        s.destroy!
      end
    end

    p.each_with_index do |p,i|

      # assign random observers
      p.observers << o[rand(0..n-1)]

      3.times do |i|
        p.colors << Color.new(:color => $colors[i], :value => 10*i+10)
      end

      10.times do |k|
        # make assignments
        a[k] = Fabricate.build(:assignment)
        a[k].save(validate: false)

        # add survey to assignment
        p_survey = s[rand(0..n-1)]
        a[k].surveys << p_survey
        a[k].survey_id = p_survey.id

        # assign trainees to assignment
        a[k].trainees << t[rand(0..n-1)]

        # generate scores for assignment -> trainee combos
        score[k] = Fabricate(:score)

        # add trainee to score
        score[k].trainee = a[k].trainees.first
        score[k].assigned_date = a[k].date


        # add random complete_date after assignment date by 1-2 days before or up to 2 after or something

        # random number of days mostly before but could be after assigned date
        random_days = rand(-2..20)

        # make sure completed date is not in the future
        score[k].completed_date = a[k].date + random_days


        if (score[k].completed_date < DateTime.now())
          score[k].completed = 't'
        else
          score[k].completed = 'f'
        end

        score[k].build_area_of_weakness
        score[k].build_area_of_strength

        ratings=[]
        ### generate ratings
        a[k].surveys.first.survey_blocks.each do |block| block.questions.each_with_index do |q , j |

            # generate ratings
            r[j] = Fabricate(:rating)

            # belongs to question
            r[j].question = q

            # add to score
            score[k].ratings << r[j]

            # belongs to observers
            r[j].observer = p.observers.first

            r[j].save

            ratings << r[j].value
          end
        end

        score[k].assignment_id = a[k].id
        score[k].save

        # add assignment to project
        p.assignments << a[k]

      end

      a[i].save
      p.save

      10.times do |k|

        ratings = []
        score[k].ratings.each do |r|
          ratings << r.value
        end
        score[k].calculate_scores(ratings,score[k].assignment.surveys[0].questions)
        score[k].save
      end

    end


    # INSERT ABOVE

  end

end