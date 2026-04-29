using System;
using System.Configuration;
using System.Data.SqlClient;
using QRCoder;
using System.Drawing;
using System.IO;

namespace StudentCertificateApp.Certificate_front
{
    public partial class Certificate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCertificate("2025SEN349"); // hardcoded
            }
        }

        private void LoadCertificate(string studentId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM CertificateOfAttendance WHERE StudentID = @StudentID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@StudentID", studentId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblName.Text = dr["StudentName"].ToString();
                    lblStudentID.Text = dr["StudentID"].ToString();
                    lblFrom.Text = dr["StudiedFrom"].ToString();
                    lblTo.Text = dr["StudiedTo"].ToString();
                    lblYear.Text = dr["Year"].ToString();
                    lblFaculty.Text = dr["Faculty"].ToString();
                    lblMajor.Text = dr["Major"].ToString();
                    lblAcademicYear.Text = dr["AcademicYear"].ToString();
                    lblApprovedBy.Text = dr["ApprovedBy"].ToString();
                    lblApprovedBy2.Text = dr["ApprovedBy"].ToString();

                    lblDate.Text = DateTime.Now.ToString("MMMM dd, yyyy");
                    lblValidity.Text = dr["AcademicYear"].ToString();

                    if (dr["BornDate"] != DBNull.Value)
                    {
                        lblDOB.Text = Convert.ToDateTime(dr["BornDate"]).ToString("MMMM dd, yyyy");
                    }

                    // Generate QR
                    GenerateQR(studentId);
                }
            }
        }

        private void GenerateQR(string studentId)
        {
            string url = "https://localhost:44363/verify?id=" + studentId;

            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeData qrCodeData = qrGenerator.CreateQrCode(url, QRCodeGenerator.ECCLevel.Q);
            QRCode qrCode = new QRCode(qrCodeData);

            using (Bitmap bitMap = qrCode.GetGraphic(20))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                    byte[] byteImage = ms.ToArray();

                    imgQR.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(byteImage);
                }
            }
        }
    }
}