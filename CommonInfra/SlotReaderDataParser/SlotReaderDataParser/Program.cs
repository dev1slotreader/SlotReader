using SlotReaderDbParser;
using System;
using System.IO;

namespace SlotReaderDataParser
{
	class Program
	{
		static void Main(string[] args)
		{
			string source = string.Format("slot_reader_source.xlsx");
			string target = string.Format("slot_reader_source");
			string command = null;

			ShowStatus(source, target);
			do
			{
				command = Console.ReadLine();
				try
				{
					ExecuteCommand(command, ref source, ref target);
				}
				catch (Exception e)
				{
					if (e is ArgumentException)
					{
						Console.WriteLine(e.Message + "Replace it?(yes/no)");
						bool isHandled = false;
						while (!isHandled)
						{
							switch (Console.ReadLine())
							{
								case "yes":
									if (command.Equals("parse to sqlite"))
										File.Delete(target + ".db3");
									else
										File.Delete(target);
									ExecuteCommand(command, ref source, ref target);
									isHandled = true;
									break;
								case "no":
									isHandled = true;
									break;
							}
						}
					}
					else if (e is FileNotFoundException)
						Console.WriteLine("Can not find the source file. Please check source path");
					else
						Console.WriteLine(e.StackTrace);

				}
			}
			while (!command.Equals("exit"));
			try
			{
				ExcelReader.GetInstance(source)?.Dispose();
			}
			catch (FileNotFoundException)
			{
				Environment.Exit(0);
			}
		}

		private static void ExecuteCommand(string command, ref string source, ref string target)
		{
			if (command.Length > 3)
			{
				if (command.Substring(0, 3).Equals("set"))
				{
					string[] separatedCommand = command.Split(' ');
					if (separatedCommand.Length >= 3)
					{
						switch (separatedCommand[1])
						{
							case "source":
								if (!separatedCommand[2].Equals(""))
								{
									source = command.Replace("set source", "");
									ShowStatus(source, target);
								}
								break;
							case "target":
								if (!separatedCommand[2].Equals(""))
								{
									target = command.Replace("set target", "");
									ShowStatus(source, target);
								}
								break;
						}
					}
				}
				else
				{
					switch (command)
					{
						case "parse to json":
							JSONWriter.WriteData(ExcelReader.GetInstance(source), target);
							Console.WriteLine("Finished");
							break;
						case "parse to sqlite":
							SQLiteWriter.createDB(ExcelReader.GetInstance(source), target);
							Console.WriteLine("Finished\n");
							break;
					}
				}
			}
		}

		private static void ShowStatus(string source, string target)
		{
			Console.WriteLine("Source path: {0}\nTarget path: {1}\n", source, target);
		}
	}
}
