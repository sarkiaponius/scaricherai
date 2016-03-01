import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;


public class DownloadChannel
{

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		File inputFile = new File("tmp/test.xml");
		File outputDir = new File("tmp/test");
		outputDir.mkdirs();
		Channel channel = new Channel(inputFile);
		byte[] chunk = new byte[4096];
		int bytesRead;
		for(Item item : channel.getItems())
		{
			try
			{
				URL u = new URL(item.getLink());
				URLConnection uc = u.openConnection();
				InputStream is = uc.getInputStream();
				String mp3 = u.getFile().replaceAll("/podcast/", "");
				FileOutputStream fos = new FileOutputStream("tmp/test/" + mp3);
				System.err.println(mp3);
				while((bytesRead = is.read(chunk)) > 0)
				{
					fos.write(chunk, 0, bytesRead);
				}
				fos.close();
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
