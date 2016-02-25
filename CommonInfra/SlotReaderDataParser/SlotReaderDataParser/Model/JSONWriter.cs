using Newtonsoft.Json;
using SlotReaderDbParser.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace SlotReaderDbParser
{
	public static class JSONWriter
	{
		public static void WriteData(ExcelReader reader, string path)
		{
			if (File.Exists(path))
				throw new ArgumentException("File is already exists.");
			else
			{
				Dictionary<string, string> writingData = new Dictionary<string, string>();
				string[] sheetNames = reader.Sheets.Select(x => x.Name.ToString()).ToArray();
				writingData.Add("charactersCount", JsonConvert.SerializeObject(sheetNames.ToArray()));
				writingData.Add("languages", JsonConvert.SerializeObject(reader.Languages.ToArray()));
				Dictionary<string, string[]> wordSet = new Dictionary<string, string[]>();
				foreach (KeyValuePair<WordKey, string[]> pair in reader.WordsSet)
					wordSet.Add(pair.Key.Language + pair.Key.ChartersCount, pair.Value);
				writingData.Add("words", JsonConvert.SerializeObject(wordSet));

				File.WriteAllText(path, JsonConvert.SerializeObject(writingData)
					.Replace("\\", "")
					.Replace("\"[", "[")
					.Replace("]\"", "]")
					.Replace("\"{","{")
					.Replace("\"}", "}"));
			}
		}
	}
}