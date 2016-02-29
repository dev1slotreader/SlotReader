namespace SlotReaderDataParser
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.Source_path_textBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.Browse_btn = new System.Windows.Forms.Button();
            this.ParseToJson_btn = new System.Windows.Forms.Button();
            this.ParseToSqlL_btn = new System.Windows.Forms.Button();
            this.SelectSource_openFD = new System.Windows.Forms.OpenFileDialog();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.SuspendLayout();
            // 
            // Source_path_textBox
            // 
            this.Source_path_textBox.Location = new System.Drawing.Point(17, 40);
            this.Source_path_textBox.Name = "Source_path_textBox";
            this.Source_path_textBox.ReadOnly = true;
            this.Source_path_textBox.Size = new System.Drawing.Size(240, 20);
            this.Source_path_textBox.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F);
            this.label1.Location = new System.Drawing.Point(13, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(153, 24);
            this.label1.TabIndex = 1;
            this.label1.Text = "Select source file";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F);
            this.label2.Location = new System.Drawing.Point(13, 68);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(100, 24);
            this.label2.TabIndex = 2;
            this.label2.Text = "Convert to:";
            // 
            // Browse_btn
            // 
            this.Browse_btn.Location = new System.Drawing.Point(263, 40);
            this.Browse_btn.Name = "Browse_btn";
            this.Browse_btn.Size = new System.Drawing.Size(81, 21);
            this.Browse_btn.TabIndex = 3;
            this.Browse_btn.Text = "Browse";
            this.Browse_btn.UseVisualStyleBackColor = true;
            this.Browse_btn.Click += new System.EventHandler(this.Browse_btn_Click);
            // 
            // ParseToJson_btn
            // 
            this.ParseToJson_btn.Location = new System.Drawing.Point(17, 95);
            this.ParseToJson_btn.Name = "ParseToJson_btn";
            this.ParseToJson_btn.Size = new System.Drawing.Size(82, 23);
            this.ParseToJson_btn.TabIndex = 4;
            this.ParseToJson_btn.Text = "JSON";
            this.ParseToJson_btn.UseVisualStyleBackColor = true;
            this.ParseToJson_btn.Click += new System.EventHandler(this.ParseToJson_btn_Click);
            // 
            // ParseToSqlL_btn
            // 
            this.ParseToSqlL_btn.Location = new System.Drawing.Point(114, 95);
            this.ParseToSqlL_btn.Name = "ParseToSqlL_btn";
            this.ParseToSqlL_btn.Size = new System.Drawing.Size(83, 23);
            this.ParseToSqlL_btn.TabIndex = 5;
            this.ParseToSqlL_btn.Text = "SQL Light";
            this.ParseToSqlL_btn.UseVisualStyleBackColor = true;
            this.ParseToSqlL_btn.Click += new System.EventHandler(this.ParseToSqlL_btn_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(373, 150);
            this.Controls.Add(this.ParseToSqlL_btn);
            this.Controls.Add(this.ParseToJson_btn);
            this.Controls.Add(this.Browse_btn);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.Source_path_textBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Name = "MainForm";
            this.Text = "SlotReader DataParser";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox Source_path_textBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button Browse_btn;
        private System.Windows.Forms.Button ParseToJson_btn;
        private System.Windows.Forms.Button ParseToSqlL_btn;
        private System.Windows.Forms.OpenFileDialog SelectSource_openFD;
        private System.Windows.Forms.SaveFileDialog saveFileDialog;
    }
}