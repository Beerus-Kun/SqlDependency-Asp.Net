using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using test19.Models;

namespace test19.Repository
{
    public interface IBaocaoRepository
    {

        List<Baocao> GetAllBaocaos();
    }
}
