# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150910182938) do

  create_table "assignments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.boolean  "completed"
    t.integer  "project_id"
    t.integer  "survey_id"
  end

  create_table "assignments_surveys", id: false, force: true do |t|
    t.integer "assignment_id"
    t.integer "survey_id"
  end

  add_index "assignments_surveys", ["assignment_id", "survey_id"], name: "index_assignments_surveys_on_assignment_id_and_survey_id"
  add_index "assignments_surveys", ["assignment_id"], name: "index_assignments_surveys_on_assignment_id"

  create_table "assignments_trainees", id: false, force: true do |t|
    t.integer "assignment_id"
    t.integer "trainee_id"
  end

  add_index "assignments_trainees", ["assignment_id", "trainee_id"], name: "index_assignments_trainees_on_assignment_id_and_trainee_id"
  add_index "assignments_trainees", ["assignment_id"], name: "index_assignments_trainees_on_assignment_id"

  create_table "competencies", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.text     "coaching"
  end

  create_table "observers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observers_projects", id: false, force: true do |t|
    t.integer "observer_id"
    t.integer "project_id"
  end

  add_index "observers_projects", ["observer_id", "project_id"], name: "index_observers_projects_on_observer_id_and_project_id"
  add_index "observers_projects", ["observer_id"], name: "index_observers_projects_on_observer_id"

  create_table "projects", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "description"
  end

  create_table "questions", force: true do |t|
    t.integer  "survey_block_id"
    t.string   "category"
    t.integer  "weight"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["survey_block_id"], name: "index_questions_on_survey_block_id"

  create_table "ratings", force: true do |t|
    t.integer  "observer_id"
    t.integer  "score_id"
    t.integer  "question_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["observer_id"], name: "index_ratings_on_observer_id"
  add_index "ratings", ["question_id"], name: "index_ratings_on_question_id"
  add_index "ratings", ["score_id"], name: "index_ratings_on_score_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "scores", force: true do |t|
    t.integer  "trainee_id"
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "skills"
    t.integer  "knowledge"
    t.integer  "abilities"
    t.integer  "total"
    t.boolean  "completed"
    t.date     "completed_date"
    t.date     "assigned_date"
  end

  add_index "scores", ["assignment_id"], name: "index_scores_on_assignment_id"
  add_index "scores", ["trainee_id"], name: "index_scores_on_trainee_id"

  create_table "survey_blocks", force: true do |t|
    t.integer  "survey_id"
    t.string   "category"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_blocks", ["survey_id"], name: "index_survey_blocks_on_survey_id"

  create_table "surveys", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "description"
  end

  create_table "trainees", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "meta_id"
    t.string   "meta_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.text     "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["meta_id", "meta_type"], name: "index_users_on_meta_id_and_meta_type"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
