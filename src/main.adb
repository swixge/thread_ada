with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   can_stop : boolean := true;
   pragma Atomic(can_stop);

   task type Stoper;

   task type My_task is
      entry Start (id : in Integer);
      entry Finish (id, sum, count : out Integer);
   end My_task;


   task body Stoper is
   begin
      delay 15.0;
      can_stop := false;
   end Stoper;


   task body My_task is
      step : Integer := 2;
      sum : Integer := 0;
      i : Integer := 0;
      id : integer;
      count : Integer := 0;
   begin
      accept Start (id : in Integer) do
         My_task.id := id;
      end Start;
      while can_stop loop
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


   num_tasks : Integer := 4;
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
