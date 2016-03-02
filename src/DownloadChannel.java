import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;

import org.apache.commons.io.FilenameUtils;

public class DownloadChannel
{

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		File inputFile = new File(args[0]);
		Channel channel = new Channel(inputFile);
		File outputDir = new File("tmp/" + channel.getTitle() + "/");
		outputDir.mkdirs();
		byte[] chunk = new byte[4096];
		int bytesRead;
		System.err.println("Channel title: " + channel.getTitle());
		System.err.println("Channel length: " + channel.getLength() / (1024*1024) + " MiB");
		System.err.println("Channel items: " + channel.getItemsCount());
		for(Item item : channel.getItems())
		{
			try
			{
				URL u = new URL(item.getLink());
				URLConnection uc = u.openConnection();
				InputStream is = uc.getInputStream();
				String mp3 = FilenameUtils.getName(u.getFile());
				File of = new File(outputDir, mp3);
				if(!of.exists())
				{
					FileOutputStream fos = new FileOutputStream(of);
					System.err.println(mp3 + "\n{");

					// legge prima un chunk, sufficiente per estrarre i tag a fini
					// diagnostici

					bytesRead = is.read(chunk);
					fos.write(chunk, 0, bytesRead);
					fos.flush();
						System.err.println("  item date: " + item.getDate());
						System.err.println("  item description: " + item.getDescription());
						System.err.println("  item channel: " + item.getChannelTitle());
						System.err.println("}");

					// adesso tira dritto a leggere tutti gli altri chunk

					while((bytesRead = is.read(chunk)) > 0)
					{
						fos.write(chunk, 0, bytesRead);
					}
					fos.close();
				}
			}
			catch(MalformedURLException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			catch(IOException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
