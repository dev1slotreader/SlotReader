using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using SlotReaderDbParser.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace SlotReaderDbParser
{
	public class ExcelReader : IDisposable
	{
		private readonly string documentPath;
		private static ExcelReader _instance;

		private string[] alphabet = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
			"V", "W", "X", "Y", "Z", };
		protected SpreadsheetDocument document;

		private List<Sheet> _sheets;
		private List<string> _languages;
		private Dictionary<WordKey, string[]> _wordsSet;

		private ExcelReader(string documentPath)
		{
			document = SpreadsheetDocument.Open(documentPath, false);
			this.documentPath = documentPath;
		}


		private string GetCellValue(string sheetName, string address)
		{
			string value = null;
			WorkbookPart wbPart = document.WorkbookPart;
			Sheet theSheet = Sheets.Where(s => s.Name == sheetName).FirstOrDefault();
			if (theSheet == null)
				throw new ArgumentException(sheetName);
			WorksheetPart wsPart = (WorksheetPart)(wbPart.GetPartById(theSheet.Id));
			Cell theCell = wsPart.Worksheet.Descendants<Cell>().Where(c => c.CellReference == address).FirstOrDefault();

			if (theCell != null && theCell.DataType != null)
			{
				value = theCell.InnerText;
				switch (theCell.DataType.Value)
				{
					case CellValues.SharedString:
						var stringTable = wbPart.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();
						if (stringTable != null)
							value = stringTable.SharedStringTable.ElementAt(int.Parse(value)).InnerText;
						break;
				}
			}
			return value;
		}

		public void Dispose()
		{
			if (_instance != null)
			{
				document.Close();
				_instance = null;
			}
		}

		public static ExcelReader GetInstance(string documentPath)
		{
			_instance = _instance == null ? new ExcelReader(documentPath) : _instance;
			if (!_instance.documentPath.Equals(documentPath))
			{
				_instance.Dispose();
				_instance = new ExcelReader(documentPath);
			}
			return _instance;
		}

		public List<Sheet> Sheets
		{
			get
			{
				if (_sheets != null)
					return _sheets;
				else
				{
					_sheets = new List<Sheet>();
					foreach (Sheet sheet in document.WorkbookPart.Workbook.Descendants<Sheet>())
						_sheets.Add(sheet);
					return _sheets;
				}
			}
		}

		public List<string> Languages
		{
			get
			{
				if (_languages != null)
					return _languages;
				else
				{
					_languages = new List<string>();
					int alphabetComplited = 0;
					int position = 0;

					foreach (Sheet sheet in Sheets)
					{
						string languageAbbreviation = null;

						do
						{
							if (alphabet.Length == position)
							{
								alphabetComplited++;
								position = 0;
							}
							string address = alphabetComplited > 0 ? alphabet[alphabetComplited] + alphabet[position] + "1" : alphabet[position] + "1";
							languageAbbreviation = GetCellValue(sheet.Name, address);
							if (languageAbbreviation != null)
								_languages.Add(languageAbbreviation);
							position++;
						}
						while (languageAbbreviation != null);
					}

					return _languages;
				}
			}
		}

		public Dictionary<WordKey, string[]> WordsSet
		{
			get
			{
				if (_wordsSet != null)
					return _wordsSet;
				else
				{
					Dictionary<WordKey, string[]> result = new Dictionary<WordKey, string[]>();
					List<string> value = new List<string>();

					foreach (Sheet sheet in Sheets)
					{
						for (int i = 0; i <= Languages.Count - 1; i++)
						{
							int alphabetComplited = 0;
							int position = 2;
							string currentValue = null;

							do
							{
								string address;
								if (alphabet.Length == i)
								{
									alphabetComplited++;
									position = 2;
								}
								if (alphabetComplited >= 1)
									address = alphabet[alphabetComplited] + alphabet[i] + (position);
								else
									address = alphabet[i] + (position);
								currentValue = GetCellValue(sheet.Name, address);
								if (currentValue != null)
									value.Add(currentValue);
								position++;
							}
							while (currentValue != null);
							result.Add(new WordKey(Languages[i], sheet.Name), value.ToArray());
							value.Clear();
						}
					}
					_wordsSet = result;
					return _wordsSet;
				}
			}
		}
	}
}
