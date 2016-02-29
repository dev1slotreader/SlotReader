using SlotReaderDbParser;
using System;
using System.IO;
using System.Windows.Forms;

namespace SlotReaderDataParser
{
	class Program
	{
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}
