require "./lib/workflow_classification"

# generates the report specified in command line args; the idea is for each
# report to configure this class
#
# this is mostly unreadable spaghetti, i'm so sorry.
class Report
  def initialize(&blk)
    instance_eval(&blk)
    send(ARGV.fetch(0))
  end

  def disagreements
    subject_data_keys = workflow_classification.subject_data_keys
    subjects = workflow_classification.subjects

    puts ["subject_id", "task", "field", "values", *subject_data_keys].to_csv

    subject_tasks.values.each do |st|
      if !st.agree?
        subject = subjects[st.subject_ids]
        subject_data = subject_data_keys.map { |k| subject[k] }
        task_name = @tasks[st.task]
        puts [st.subject_ids, st.task, task_name, *st.values.join("|"), *subject_data].to_csv
      end
    end
  end

  def table
    sts = subject_tasks
    subject_keys = workflow_classification.subject_data_keys
      .reject { |k| /^url_/ =~ k }
    puts ["subject_id", *subject_keys, *@tasks.values, *@columns.keys].to_csv
    workflow_classification.subjects.each do |subject_id, subject_data|
      puts [
        subject_id,
        *subject_keys.map { |k| subject_data[k] },
        *(@tasks.keys.map do |task|
          st = sts[[subject_id, task]]
          raise "unable to find #{subject_id} #{task}" if !st
          st.value
        end),
        *(@columns.map do |name, p|
          p.call(subject_data)
        end)
      ].to_csv
    end
  end

  private
  def column(name, &blk)
    @columns ||= {}
    @columns[name] = blk
  end

  def file(file)
    @file = file
  end

  def task(number, name)
    @tasks ||= {}
    @tasks["T#{number}"] = name
  end

  def correct(subject_id, task, value)
    @corrections ||= {}
    @corrections[[subject_id, task]] = value
  end

  def workflow_classification
    @workflow_classification ||= WorkflowClassification.new(@file)
  end

  def subject_ids_to_annotations 
    workflow_classification.annotations
      .group_by { |a| a.classification.subject_ids }
  end

  def subject_tasks
    workflow_classification.annotations
      .group_by { |a| [a.classification.subject_ids, a.task] }
      .map { |k,v| [k, SubjectTask.new(v, k[0], k[1], @corrections[[k[0].to_i, k[1]]])] }
      .to_h
  end

  class SubjectTask
    attr_reader :subject_ids, :task

    def initialize(annotations, subject_ids, task, correction)
      @annotations = annotations
      @subject_ids = subject_ids
      @task = task
      @correction = correction
    end

    def agree?
      @correction || values.uniq.count == 1
    end

    def values
      @annotations.map(&:value)
    end

    def value
      @correction || @annotations.first.value
    end
  end
end
