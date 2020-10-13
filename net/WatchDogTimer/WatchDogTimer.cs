using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ServiceProcess
{
    public class WatchDogTimer
    {

        private long _counter = 0;

        private long _time_stop = 0;

        private long _time_inactivity = 0;


        Task task_counter = null;

        #region PROPERTIES

        public long time_inactivity
        {
            get
            {
                return this._time_inactivity;
            }
            set
            {
                this._time_inactivity = value;
            }
        }

        public long time_stop
        {
            get
            {
                return this._time_stop;
            }
            set
            {
                if (value > 0)
                {
                    this._time_stop = value;
                }
                else
                {
                    System.ArgumentException argEx = new System.ArgumentException("Index is out of range", "time_stop");
                    throw argEx;
                }
                
            }
        }

        #endregion

        #region EVENTS

        public event EventHandler inactivity;
        public event EventHandler time_end;
        public event EventHandler timer;

        #endregion

        public void start() {

            

            if (_time_stop > 0)
            {
                //task_counter = Task.Factory.StartNew(() => counter());

                task_counter = new Task(new Action (counter));

                task_counter.Start();

            }
            else {
                System.ArgumentException argEx = new System.ArgumentException("Index is out of range", "time_stop");
                throw argEx;
            }

        }



        private void counter() {

            while (_counter < _time_stop)
            {
                Thread.Sleep(1000); 
                _counter++;

                if ((_time_inactivity > 0) && ((_counter % _time_inactivity) == 0) && (inactivity != null)) {
                    inactivity(_counter, null);
                }

                if (timer != null) {
                    timer(_counter, null);
                }
            }

            if (time_end != null) {
                time_end(_counter, null);
            }

        }
        
    }
}
