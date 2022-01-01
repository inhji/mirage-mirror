defmodule Mirage.LoggerTest do
  use Mirage.DataCase

  alias Mirage.Logger

  describe "logger" do
    test "log/3 inserts a log entry" do
      {:ok, log} = Logger.log("Some Message", :info, %{})
      assert log.message == "Some Message"
      assert log.level == :info
    end

    test "log/3 with metadata inserts a log entry" do
      {:ok, log} = Logger.log("Some Message", :info, %{request_id: 123})
      assert log.message == "Some Message"
      assert log.level == :info
      assert log.metadata.request_id == 123
    end

    test "list_logs/1 lists and filters logs by options" do
      {:ok, _log1} = Logger.log("Some Message1", :info, %{request_id: 123})
      {:ok, _log2} = Logger.log("Some Message2", :error, %{request_id: 123})
      {:ok, _log3} = Logger.log("Some Message3", :info, %{request_id: 123})

      logs = Logger.list_logs(level: :info)
      assert Enum.count(logs) == 2
    end
  end
end
