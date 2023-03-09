with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   num_tasks : Integer := 4;
   Can_stop : array (1..num_tasks) of Boolean := (others => true);

   --can_stop : boolean := true;
   pragma Atomic(Can_stop);

   task type Stoper is
      entry Start_Stoper (Timer : in Duration; id : in Integer);
   end Stoper;

   task body Stoper is
      Timer : Duration;
      id : integer;
   begin
      accept Start_Stoper (Timer : in Duration; id : in Integer) do
         Stoper.Timer := Timer;
         Stoper.id := id;
      end Start_Stoper;
      delay Timer;
      Can_stop(id) := false;
   end Stoper;


   task type My_task is
      entry Start (id : in Integer);
      entry Finish (id, sum, count : out Integer);
   end My_task;

   task body My_task is
      step : Integer := 2;
      sum : Integer := 0;
      i : Integer := 0;
      id : integer;
      count : Integer := 0;
      stop : Stoper;
   begin
      accept Start (id : in Integer) do
         My_task.id := id;
      end Start;
      stop.Start_Stoper(10.0, id);
      while Can_stop(id) loop
         sum := sum + i;
         count := count + 1;
         i := i + step;
      end loop;
      accept Finish (id : out Integer; sum : out Integer; count : out Integer) do
         id := My_task.id;
         sum := My_task.sum;
         count := My_task.count;
      end Finish;
   end My_task;

   A : Array(1..num_tasks) of My_task;
   id_array : Array(1..num_tasks) of integer;
   count_array : Array(1..num_tasks) of integer;
   sum_array : Array(1..num_tasks) of integer;

begin


   for i in A'Range loop
      A(i).Start(i);
   end loop;



   for i in A'Range loop
      A(i).Finish(id_array(i), sum_array(i), count_array(i));
      Put_Line(id_array(i)'Img & " " & sum_array(i)'Img & " " & count_array(i)'Img);
   end loop;

end Main;
