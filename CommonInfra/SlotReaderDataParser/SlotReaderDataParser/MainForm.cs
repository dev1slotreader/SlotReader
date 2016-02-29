using SlotReaderDbParser;
using System;
using System.Windows.Forms;

namespace SlotReaderDataParser
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
            SelectSource_openFD.Filter = "Excel Worksheets 2007(*.xlsx)|*.xlsx|Excel Worksheets 2003(*.xls)|*.xls";
            ConvertButtonsEnabled(false);
        }

        private void Browse_btn_Click(object sender, EventArgs e)
        {
            DialogResult result = SelectSource_openFD.ShowDialog();
            if (result == DialogResult.OK)
            {
                Source_path_textBox.Text = SelectSource_openFD.FileName;
                ConvertButtonsEnabled(true);
            }
        }
        private void ParseToJson_btn_Click(object sender, EventArgs e)
        {
            ConvertButtonsEnabled(false);
            saveFileDialog.Filter = "JSON File|*.json";
            saveFileDialog.FileName = null;
            DialogResult result = saveFileDialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                Cursor.Current = Cursors.WaitCursor;
                try
                {
                    JSONWriter.WriteData(ExcelReader.GetInstance(Source_path_textBox.Text), saveFileDialog.FileName);
                    MessageBox.Show("Finished");
                }
                catch (Exception exc)
                {
                    MessageBox.Show(exc.Message+"\n" + exc.InnerException+" "+exc.StackTrace, "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            ConvertButtonsEnabled(true);
        }

        private void ParseToSqlL_btn_Click(object sender, EventArgs e)
        {
            ConvertButtonsEnabled(false);
            saveFileDialog.Filter = "SQL Light|*.db3";
            saveFileDialog.FileName = null;
            DialogResult result = saveFileDialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                Cursor.Current = Cursors.WaitCursor;
                try
                {
                    SQLiteWriter.createDB(ExcelReader.GetInstance(Source_path_textBox.Text), saveFileDialog.FileName);
                MessageBox.Show("Finished");
                }
                catch (Exception exc)
                {
                    MessageBox.Show(exc.Message + "\n" + exc.InnerException + " " + exc.StackTrace, "Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            ConvertButtonsEnabled(true);
        }
        private void ConvertButtonsEnabled(bool flag)
        {
            ParseToJson_btn.Enabled = flag;
            ParseToSqlL_btn.Enabled = flag;
        }
    }
}
