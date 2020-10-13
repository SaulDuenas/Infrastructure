using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace ServiceProcess
{
    public abstract class TaskProcess
    {

        Task task_process = null;

        Boolean IsRepeatable = true;

        readonly WatchDogTimer wdt = null;

        public abstract void  ServiceProcess();


       
       


        TaskProcess(long time_stop,long time_inactivity) {

            wdt = new WatchDogTimer();
            wdt.time_stop = time_stop;
            wdt.time_inactivity = time_inactivity;

            wdt.inactivity += new EventHandler(Inactivity);
            wdt.timer += new EventHandler(Timer);
            wdt.time_end += new EventHandler(Time_End);

        }


        public void start_process()
        {
            CancellationTokenSource tokenSource2 = new CancellationTokenSource();
            CancellationToken ct = tokenSource2.Token;

            task_process = new Task(new Action(running), tokenSource2.Token);

            task_process.Start();

            wdt.start();

        }


        private void running() {


            do
            {
                ServiceProcess();

            } while (IsRepeatable);

        }



        private void Inactivity(object sender, EventArgs e)
        {
            //Escribimos en la consola el contenido de la variable txt
            Console.WriteLine("3 segundos de Inactividad ");

        }

        private void Timer(object sender, EventArgs e)
        {
            //Escribimos en la consola el contenido de la variable txt
            Console.WriteLine("Counter -> " + (long)sender);

        }


        private void Time_End(object sender, EventArgs e)
        {
            IsRepeatable = false;
           

            //Escribimos en la consola el contenido de la variable txtdñ
            Console.WriteLine(" WatchDog End");

            task_process.Wait();
           // task_process.a
        }


    }
}
