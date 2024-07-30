using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Rebar;
using System.Reflection;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.TaskbarClock;

namespace giaodien
{
    public partial class Form1 : Form
    {
        public string nhietdo1;
       
        public Form1()
        {
            InitializeComponent();
        }
        string[] mahex = { "FOBD", "E17B", "D239", "C2F6", "B3B4", "A472", "9530", "85ED", "76AB", "6769" };
        string[] thoigian = { "0.5s", "1s", "1.5s", "2s", "2.5s", "3s", "3.5s", "4s", "4.5s", "5s" };
        string[] pause = { "1200", "2400", "4800", "9600", "19200", "38400", "57600", "14880" };
        private Dictionary<string, string> timer = new Dictionary<string, string>();
        private void Form1_Load(object sender, EventArgs e)
        {
            string[] namecom = SerialPort.GetPortNames();
            com.Items.AddRange(namecom);
            baudrate.Items.AddRange(pause);
            cacthoigian.Items.AddRange(thoigian);

            for (int i = 0; i < thoigian.Length; i++)
            {
                timer.Add(thoigian[i], mahex[i]);
            }
        }
        //

        private void ketnoi_Click(object sender, EventArgs e)
        {
            try
            {
                if (com.Text == "" || baudrate.Text == "")
                {
                    MessageBox.Show("Bạn chưa nhập đủ thông tin", "Thông  báo");
                }
                if (serialPort1.IsOpen)
                {
                    serialPort1.Close();
                    ketnoi.Text = "KẾT NỐI";
                }
                else
                {
                    serialPort1.PortName = com.Text;
                    serialPort1.BaudRate = int.Parse(baudrate.Text);
                    serialPort1.Open();
                    ketnoi.Text = "NGẮT KẾT NỐI";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }

        }
        
        private void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            string dulieu = serialPort1.ReadLine().ToString();
            string time = DateTime.Now.ToString("HH:mm:ss");
            if (int.TryParse(dulieu, out int nhietdo1))
            {
                dulieu = nhietdo1.ToString();
                // Display temperature in textbox1
                BeginInvoke(new Action(() =>
                {
                    nhietdo.Text = nhietdo1.ToString();
                    chart1.Series[0].Points.AddXY(time, nhietdo1);
                }));
            }
            else
            {
               
                BeginInvoke(new Action(() =>
                {
                    counter.Text = dulieu; 
                }));
            }

        }

        private void den1_Click(object sender, EventArgs e)
        {
            if (den1.Text == "bật đèn 1")
            {
                serialPort1.Write("l");
                led1.Image = global::giaodien.Properties.Resources.batden1;
                den1.Text = "Tắt Đèn";
                den1.BackColor = Color.LightSalmon;
            }
            else if (den1.Text == "Tắt Đèn")
            {
                serialPort1.Write("a");
                led1.Image = global::giaodien.Properties.Resources.tatden1;
                den1.Text = "bật đèn 1";
                den1.BackColor = Color.NavajoWhite;
            }
        }

        private void den2_Click(object sender, EventArgs e)
        {
            if (den2.Text == "bật đèn 2")
            {
                serialPort1.Write("m");
                led2.Image = global::giaodien.Properties.Resources.batden1;
                den2.Text = "Tắt Đèn";
                den2.BackColor = Color.LightSalmon;
            }
            else if (den2.Text == "Tắt Đèn")
            {
                serialPort1.Write("b");
                led2.Image = global::giaodien.Properties.Resources.tatden1;
                den2.Text = "bật đèn 2";
                den2.BackColor = Color.NavajoWhite;
            }
        }

        private void den3_Click(object sender, EventArgs e)
        {
            if (den3.Text == "bật đèn 3")
            {
                serialPort1.Write("n");
                led3.Image = global::giaodien.Properties.Resources.batden1;
                den3.Text = "Tắt Đèn";
                den3.BackColor = Color.LightSalmon;
            }
            else if (den3.Text == "Tắt Đèn")
            {
                serialPort1.Write("c");
                led3.Image = global::giaodien.Properties.Resources.tatden1;
                den3.Text = "bật đèn 3";
                den3.BackColor = Color.NavajoWhite;
            }
        }

        private void den4_Click(object sender, EventArgs e)
        {
            if (den4.Text == "bật đèn 4")
            {
                serialPort1.Write("o");
                led4.Image = global::giaodien.Properties.Resources.batden1;
                den4.Text = "Tắt Đèn";
                den4.BackColor = Color.LightSalmon;
            }
            else if (den4.Text == "Tắt Đèn")
            {
                serialPort1.Write("d");
                led4.Image = global::giaodien.Properties.Resources.tatden1;
                den4.Text = "bật đèn 4";
                den4.BackColor = Color.NavajoWhite;
            }
        }

        private void den5_Click(object sender, EventArgs e)
        {
            if (den5.Text == "bật đèn 5")
            {
                serialPort1.Write("u");
                led5.Image = global::giaodien.Properties.Resources.batden1;
                den5.Text = "Tắt Đèn";
                den5.BackColor = Color.LightSalmon;
            }
            else if (den5.Text == "Tắt Đèn")
            {
                serialPort1.Write("e");
                led5.Image = global::giaodien.Properties.Resources.tatden1;
                den5.Text = "bật đèn 5";
                den5.BackColor = Color.NavajoWhite;
            }
        }

        private void den6_Click(object sender, EventArgs e)
        {
            if (den6.Text == "bật đèn 6")
            {
                serialPort1.Write("i");
                led6.Image = global::giaodien.Properties.Resources.batden1;
                den6.Text = "Tắt Đèn";
                den6.BackColor = Color.LightSalmon;
            }
            else if (den6.Text == "Tắt Đèn")
            {
                serialPort1.Write("f");
                led6.Image = global::giaodien.Properties.Resources.tatden1;
                den6.Text = "bật đèn 6";
                den6.BackColor = Color.NavajoWhite;
            }
        }

        private void den7_Click(object sender, EventArgs e)
        {
            if (den7.Text == "bật đèn 7")
            {
                serialPort1.Write("v");
                led7.Image = global::giaodien.Properties.Resources.batden1;
                den7.Text = "Tắt Đèn";
                den7.BackColor = Color.LightSalmon;
            }
            else if (den7.Text == "Tắt Đèn")
            {
                serialPort1.Write("g");
                led7.Image = global::giaodien.Properties.Resources.tatden1;
                den7.Text = "bật đèn 7";
                den7.BackColor = Color.NavajoWhite;
            }
        }

        private void den8_Click(object sender, EventArgs e)
        {
            if (den8.Text == "bật đèn 8")
            {
                serialPort1.Write("x");
                led8.Image = global::giaodien.Properties.Resources.batden1;
                den8.Text = "Tắt Đèn";
                den8.BackColor = Color.LightSalmon;
            }
            else if (den8.Text == "Tắt Đèn")
            {
                serialPort1.Write("h");
                led8.Image = global::giaodien.Properties.Resources.tatden1;
                den8.Text = "bật đèn 8";
                den8.BackColor = Color.NavajoWhite;
            }
        }


        private void quat_Click(object sender, EventArgs e)
        {
            if (quat.Text == "Bật quạt")
            {
                serialPort1.Write("y");
                hinhquat.Image = global::giaodien.Properties.Resources.quatbat;
                quat.Text = "Tắt quạt";
                quat.BackColor = Color.LightSalmon;
            }
            else if (quat.Text == "Tắt quạt")
            {
                serialPort1.Write("j");
                hinhquat.Image = global::giaodien.Properties.Resources.quat_tat;
                quat.Text = "Bật quạt";
                quat.BackColor = Color.NavajoWhite;
            }
        }

        private void guidulieu_Click(object sender, EventArgs e)
        {
            if (cacthoigian.Text == "")
            {
                MessageBox.Show("Hãy cài đặt thời gian đèn chớp!", "Thông báo");
            }
            else
            {                if (serialPort1.IsOpen)
                {
                    string selectedTime = cacthoigian.SelectedItem.ToString();
                    string dulieuHex = timer[selectedTime];
                    serialPort1.WriteLine(dulieuHex); // Gửi mã hex thời gian
                }
                else
                {
                    MessageBox.Show("Vui lòng kết nối trước!", "Thông báo");
                }
            }
        }

        private void reset_Click(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen)
            {
                serialPort1.WriteLine("RESET");

                BeginInvoke(new Action(() =>
                {
                    counter.Text = "Counter: 00";
                }));
            }
            else
            {
                MessageBox.Show("Vui lòng kết nối", "Thông báo");
            }
        }
    }
}

