require "csv"
require "json"

# class for working with a Workflow Classification report exported from Zooniverse
class WorkflowClassification
  attr_reader :classifications

  def initialize(filepath)
    @classifications = CSV.foreach(filepath, headers: true).map { |c| Classification.new(c) }
  end

  def annotations
    classifications.flat_map(&:annotations)
  end

  def subject_data_keys
    keys = classifications.map(&:subject_data)
      .flat_map(&:keys)
      .sort
      .uniq
    keys.delete("retired")
    keys
  end

  def subjects
    classifications
      .inject({}) { |h,c| h[c.subject_ids] = c.subject_data; h }
  end

  class Classification
    attr_reader :subject_data, :annotations, :user_name, :user_ip, :workflow_version, :metadata, :subject_ids

    def initialize(attributes)
      @subject_data = JSON.parse(attributes["subject_data"]).values.first
      @user_name = attributes["user_name"]
      @user_ip = attributes["user_ip"]
      @workflow_version = attributes["workflow_version"]
      @metadata = JSON.parse(attributes["metadata"])
      @annotations = JSON.parse(attributes["annotations"]).map { |a| Annotation.new(a, self) }
      @subject_ids = attributes["subject_ids"]
    end
  end

  class Annotation
    attr_reader :task, :task_label, :value, :classification

    def initialize(attributes, classification)
      @task = attributes["task"]
      @task_label = attributes["task_label"]
      @value = attributes["value"].strip
      @classification = classification
    end
  end
end
