using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using test19.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.SignalR;

namespace test19.Repository
{
    public class BaocaoRepository : IBaocaoRepository
    {

        string connectionString = "";
        private readonly IHubContext<SignalServer> _context;
        public BaocaoRepository(IConfiguration configuration, IHubContext<SignalServer> context)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
            _context = context;
        }
        public List<Baocao> GetAllBaocaos()
        {
            var baocaos = new List<Baocao>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlDependency.Start(connectionString);
                string commandText = "select * from baocao";
                SqlCommand cmd = new SqlCommand(commandText, conn);
                SqlDependency dependency = new SqlDependency(cmd);
                dependency.OnChange += new OnChangeEventHandler(dbChangeNotification);

                var reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    Console.WriteLine(1);
                    var baocao = new Baocao
                    {
                        macp = reader["macp"].ToString(),
                        tran = reader["tran"] != DBNull.Value ? (float)Convert.ToDouble(reader["tran"]) : -1,
                        san = reader["san"] != DBNull.Value ? (float)Convert.ToDouble(reader["san"]) : -1,
                        tc = reader["tc"] != DBNull.Value ? (float)Convert.ToDouble(reader["tc"]) : -1,
                        giamua1 = reader["giamua1"] != DBNull.Value ? (float)Convert.ToDouble(reader["giamua1"]) : -1,
                        giamua2 = reader["giamua2"] != DBNull.Value ? (float)Convert.ToDouble(reader["giamua2"]) : -1,
                        giamua3 = reader["giamua3"] != DBNull.Value ? (float)Convert.ToDouble(reader["giamua3"]) : -1,
                        giakhoplenh = reader["giakhoplenh"] != DBNull.Value ? (float)Convert.ToDouble(reader["giakhoplenh"]) : -1,
                        giaban1 = reader["giaban1"] != DBNull.Value ? (float)Convert.ToDouble(reader["giaban1"]) : -1,
                        giaban2 = reader["giaban2"] != DBNull.Value ? (float)Convert.ToDouble(reader["giaban2"]) : -1,
                        giaban3 = reader["giaban3"] != DBNull.Value ? (float)Convert.ToDouble(reader["giaban3"]) : -1,
                        tb = reader["tb"] != DBNull.Value ? (float)Convert.ToDouble(reader["tb"]) : -1,
                        cao = reader["cao"] != DBNull.Value ? (float)Convert.ToDouble(reader["cao"]) : -1,
                        thap = reader["thap"] != DBNull.Value ? (float)Convert.ToDouble(reader["thap"]) : -1,
                        klmua1 = reader["klmua1"] != DBNull.Value ? Convert.ToInt32(reader["klmua1"]) : -1,
                        klmua2 = reader["klmua2"] != DBNull.Value ? Convert.ToInt32(reader["klmua2"]) : -1,
                        klmua3 = reader["klmua3"] != DBNull.Value ? Convert.ToInt32(reader["klmua3"]) : -1,
                        klban1= reader["klban1"] != DBNull.Value ? Convert.ToInt32(reader["klban1"]) : -1,
                        klban2 = reader["klban2"] != DBNull.Value ? Convert.ToInt32(reader["klban2"]) : -1,
                        klban3 = reader["klban3"] != DBNull.Value ? Convert.ToInt32(reader["klban3"]) : -1,
                        klkhoplenh = reader["klkhoplenh"] != DBNull.Value ? Convert.ToInt32(reader["klkhoplenh"]) : -1,
                        tongkl = reader["tongkl"] != DBNull.Value ? Convert.ToInt32(reader["tongkl"]) : -1,
                        dumua = reader["dumua"] != DBNull.Value ? Convert.ToInt32(reader["dumua"]) : -1,
                        duban = reader["duban"] != DBNull.Value ? Convert.ToInt32(reader["duban"]) : -1
                    };


                    baocaos.Add(baocao);
                }
            }
            return baocaos;
        }

        private void dbChangeNotification(object sender, SqlNotificationEventArgs e)
        {
            _context.Clients.All.SendAsync("refreshBaocaos");
        }
    }
}
