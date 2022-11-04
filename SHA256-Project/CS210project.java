package com.company;
import java.io.*;
import java.util.Random;
import java.util.Scanner;
import java.security.MessageDigest;

public class CS210project
{
    public static void main(String [] args) throws FileNotFoundException
    {
        Scanner sc = new Scanner(new File("C://Users/iulib/Desktop/listofwords.txt"));
        //*The scanner above contains the file path that will allow me to read the text file into program.*//
        int num = 0; //*stores the number of sentences that have been generated*//
        int max = 0; //*stores the highest match that has been found*//
        //*The for loops below read in the contents of the text file, so that they can be stored within the arrays.*//
        //*The arrays each have a set size to store the words corresponding to their variable name.*//

        String [] names = new String[111];

        for (int i = 0; i < 111; i++)
        {
           names[i] = sc.nextLine();
        }

        String [] names2 = new String[111];

        for (int i = 0; i < 111; i++)
        {
           names2[i] = sc.nextLine();
        }

        String [] words = new String[8];

        for (int i = 0; i < 8; i++)
        {
           words[i] = sc.nextLine();
        }

        String [] words2 = new String[11];

        for (int i = 0; i < 11; i++)
        {
           words2[i] = sc.nextLine();
        }

        String [] places = new String[278];

        for (int i = 0; i < 278; i++)
        {
           places[i] = sc.nextLine();
        }
        
        String [] general = new String[1498];

        for (int i = 0; i < 1498; i++)
        {
           general[i] = sc.nextLine().toLowercase();
        }
        String[] array = new String[1]; //*Array for the first sentence*//
        String[] array2 = new String[1]; //*Array for the second sentence*//
        String ans = null; //*stores the first sentence of the pair that give the highest match*//
        String ans2 = null; //*stores the second sentence of the pair that give the highest match*//
        //*for loop used to print out 'x' number of sentences*//
        for (int x = 0; x < 600000; x++)
        {
            Random rand = new Random(); //*Used to randomise words from each array*//
            int i1 = rand.nextInt(names.length);
            int i2 = rand.nextInt(words.length);
            int i3 = rand.nextInt(words2.length);
            int i4 = rand.nextInt(places.length);
            int i5 = rand.nextInt(general.length);
            int i6 = rand.nextInt(names2.length);
            //*Prints out a random sentence along with its hash value*//
            for (int i = 0; i < array.length; i++)
            {
               array[i] = names[i1] + " " + words[i2] + " to " + places[i4] + "!";
               System.out.println(array[i].trim() + ": " + sha256(array[i]).trim());
            }
            for (int i = 0; i < array2.length; i++)
            {
               array2[i] = names2[i6] + " " + words2[i3] + " " + general[i5] + "s" + ".";
               System.out.println(array2[i].trim() + ": " + sha256(array2[i]).trim());
            }
            //*Nested for loop that prints out the number of similarities of each sentence*//
            //*Contains code to find the highest match found along with its//
            //corresponding sentences*//

            for (int i = 0; i < array.length; i++)
            {
                for (int j = 0; j < array2.length; j++)
                {
                    int sim = check(sha256(array[i]), sha256(array2[j]));
                    System.out.println(sim);
                    if(sim > 14)
                    {
                        max = sim;
                        ans = array[i];
                        ans2 = array2[j];
                    }
                }
            }
            num++;
        }
        System.out.println("Highest match found: " + max); //*Prints highest match*//
        System.out.println(ans + ": " + sha256(ans)); //*Prints 1st sentence of match//
        System.out.println(ans2 + ": " + sha256(ans2)); //*Prints 2nd sentence of match*//
        System.out.println("Number of sentences printed: " + num);
    }

    public static String sha256(String input)
    {
        try
        {
            MessageDigest mDigest = MessageDigest.getInstance("SHA-256");
            byte[] salt = "CS210+".getBytes("UTF-8");
            mDigest.update(salt);
            byte[] data = mDigest.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < data.length; i++)
            {
                sb.append(Integer.toString((data[i] & 0xff) + 0x100, 16).substring(1));
            }
            return sb.toString();
        }
        catch (Exception e)
        {
            return (e.toString());
        }
    }

    //*Method used to check the similarities of two sentences*//
    public static int check (String hash1, String hash2)
    {
        int p = 0;
        int c = 0;
        while(p < hash1.length() && p < hash2.length())
        {
            if(hash1.charAt(p) == hash2.charAt(p)) //*If the same character is found in this position,//
            { 
                //increase count by 1.*//
                c++;
            }
            p++;
        }
        return c; //*Return amount of similarities found*//
    }
}

