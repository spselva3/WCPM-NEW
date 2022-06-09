using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WCPM
{
    class clsJsonData
    {
        public string fromdate;
        public string todate;
        public string custmername;
        public List<string> deviceMacIds = new List<string>();

    }
    class clsJsonDataforBarcode
    {
        public string reelId;
        public string lotNumber;
        public string quality;
        public string size;
        public string gsm;
        public string mfgData;
        public string shift;
     
      

    }
}