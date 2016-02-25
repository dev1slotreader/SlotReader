using System;
using System.Collections.Generic;
using System.Data.SQLite;
using System.IO;
using SlotReaderDbParser.Model;

namespace SlotReaderDbParser
{
	public static class SQLiteWriter
	{
		public static void createDB(ExcelReader reader, string db_name)
		{
			db_name += ".db3";
			if (!File.Exists(db_name))
				SQLiteConnection.CreateFile(db_name);
			else
				throw new ArgumentException("File is already exists");
			using (SQLiteConnection connection = new SQLiteConnection(string.Format("data source = {0}", db_name)))
			{
				connection.Open();
				using (SQLiteCommand command = new SQLiteCommand(connection))
				{
					command.CommandText = "CREATE TABLE languages ( _id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)";
					command.ExecuteNonQuery();
					command.CommandText = "CREATE TABLE words ( _id INTEGER PRIMARY KEY AUTOINCREMENT, language_id INTEGER, symbol_count TEXT NOT NULL,"
						+ "word TEXT NOT NULL)";
					command.ExecuteNonQuery();
					foreach (string languageName in reader.Languages)
					{
						command.CommandText = string.Format("INSERT INTO languages (name) VALUES ('{0}')", languageName);
						command.ExecuteNonQuery();
					}

					foreach (KeyValuePair<WordKey, string[]> item in reader.WordsSet)
					{
						int wordsCount = 0;
						string commandStr = "INSERT INTO words (language_id, symbol_count, word) VALUES ";
						foreach (string word in item.Value)
						{
							if(wordsCount > 0)
								commandStr += string.Format(",('{0}', '{1}', '{2}')", reader.Languages.IndexOf(item.Key.Language) + 1, item.Key.ChartersCount, word);
							else
								commandStr += string.Format("('{0}', '{1}', '{2}')", reader.Languages.IndexOf(item.Key.Language) + 1, item.Key.ChartersCount, word);
							wordsCount++;
						}
						command.CommandText = commandStr;
						command.ExecuteNonQuery();
					}
				}
				connection.Close();
			}
		}
	}
}
