with Ada.Text_IO, ada.long_Integer_Text_IO;
use Ada.Text_IO, ada.long_Integer_Text_IO;

procedure Main is
type ArrayOfLongInteger is array(Long_Integer range<>) of Long_Integer;

   arr: ArrayOfLongInteger(0..9);
   countOfPartOfArray: Long_Integer := 4;

   function calculatePartiralSum (firstIndex, secondIndex : in Long_Integer) return Long_Integer is
      partSum : Long_Integer := 0;
   begin
      for i in firstIndex .. secondIndex loop
         partSum := partSum + arr(i);
      end loop;

      return partSum;
   end calculatePartiralSum;

   task type TaskCalculatePartiralSum is
      entry beginCalculatePartiralSum (firstIndex, secondIndex : in Long_Integer);
      entry endCalculatePartiralSum (calculatePartiralSum : out Long_Integer);
   end;

   task body TaskCalculatePartiralSum is
      firstIndex, secondIndex, result : Long_Integer;
   begin
      accept beginCalculatePartiralSum (firstIndex, secondIndex : Long_Integer) do
         TaskCalculatePartiralSum.firstIndex := firstIndex;
         TaskCalculatePartiralSum.secondIndex := secondIndex;
      end beginCalculatePartiralSum;

      result := calculatePartiralSum(firstIndex, secondIndex);

      accept endCalculatePartiralSum (calculatePartiralSum : out Long_Integer) do
         calculatePartiralSum := result;
      end endCalculatePartiralSum;
   end TaskCalculatePartiralSum;

   function calculateSum(arr : in ArrayOfLongInteger; length, countOfPartOfArray : in Long_Integer) return Long_Integer is
      firstIndex : Long_Integer := arr'First;
      secondIndex, sum, partSum: Long_Integer;

      lengthPartArr : Long_Integer := length / countOfPartOfArray;
      arr_2 : array (0 .. countOfPartOfArray - 1) of TaskCalculatePartiralSum;
   begin
      for i in arr_2'Range loop
         secondIndex := firstIndex + lengthPartArr;
         arr_2(i).beginCalculatePartiralSum(firstIndex, secondIndex - 1);
         firstIndex := secondIndex;
      end loop;

      sum := calculatePartiralSum (firstIndex, arr'Last);

      for i in arr_2'Range loop
         arr_2(i).endCalculatePartiralSum(partSum);
         sum := sum + partSum;
      end loop;

      return sum;
   end calculateSum;

   function calculateSum_2(arr : in ArrayOfLongInteger) return Long_Integer is
      tempArray : ArrayOfLongInteger(0 .. 9);
      counter, innerCounter, outerCounter, tempVar : Long_Integer := 0;
   begin
      for i in arr'First .. arr'Last loop
         tempArray(i) := Long_Integer(i);
      end loop;

      tempVar := tempArray'Length / 2;
      loop
         counter := counter + 1;

         if (outerCounter = 0) then
            tempArray(innerCounter) := tempArray(innerCounter) + tempArray(tempArray'Length - 1 - innerCounter);
         else
            tempArray(innerCounter) := tempArray(innerCounter) + tempArray(tempArray'Length - 2 - outerCounter);
         end if;

         innerCounter := innerCounter + 1;

         if(innerCounter = tempVar) then
            loop
               tempArray(innerCounter) := 0;
               innerCounter := innerCounter + 1;
               outerCounter := outerCounter + 1;

               if (innerCounter = tempArray'Length - 1) then
                  exit;
               end if;

            end loop;

            if(outerCounter = arr'Length) then
               outerCounter := 0;
            end if;

            tempVar := (tempVar / 2) + 1;
            innerCounter := 0;
         end if;

         if (counter > tempArray'Length) then
            return tempArray(0);
         end if;

      end loop;

   end calculateSum_2;

begin
   for i in arr'First .. arr'Last loop
      arr(i) := Long_Integer(i);
   end loop;

   Put("Sum of First Method:");
   Put(calculateSum(arr, arr'Length, countOfPartOfArray)'Image);
   New_Line;
   Put("Sum of Second Method:");
   Put(calculateSum_2(arr)'Image);
end Main;
