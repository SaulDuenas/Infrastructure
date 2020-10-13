using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using ServiceProcess;

namespace ConsoleApplicationDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            WatchDogTimer wdt = new WatchDogTimer();

            wdt.time_stop = 15;
            wdt.time_inactivity = 3;
            wdt.inactivity += new EventHandler(Inactivity);
            wdt.timer += new EventHandler(Timer);
            wdt.time_end += new EventHandler(Time_End);

            Console.WriteLine("iniciando conteo ");

            wdt.start();

            Console.ReadLine();
        }



        static void Inactivity(object sender, EventArgs e)
        {
            //Escribimos en la consola el contenido de la variable txt
            Console.WriteLine("3 segundos de Inactividad ");
            
        }

        static void Timer(object sender, EventArgs e)
        {
            //Escribimos en la consola el contenido de la variable txt
            Console.WriteLine("Counter -> " + (long)sender);

        }


        static void Time_End(object sender, EventArgs e)
        {
            //Escribimos en la consola el contenido de la variable txt
            Console.WriteLine(" WatchDog End");

        }
    }
}
