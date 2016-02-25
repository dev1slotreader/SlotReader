using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SlotReaderDbParser.Model
{
	public class WordKey
	{
		public WordKey(string language, string charterCount)
		{
			Language = language;
			ChartersCount = charterCount;
		}
		public string Language { get; }
		public string ChartersCount { get; }
	}
}
