json.extract! seminar, :id, :title, :subtitle, :teacher_id, :benefit, :content, :notes, :max_attendees, :location_id, :created_at, :updated_at
json.url seminar_url(seminar, format: :json)