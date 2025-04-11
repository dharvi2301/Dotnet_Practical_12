using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Test_3.Models
{
	public class Designation
	{
        [Required]
        public int Identifier { get; set; }
    }
}