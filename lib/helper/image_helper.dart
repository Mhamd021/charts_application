class ImageHelper {
  static String getValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return ''; // Return empty string or a placeholder image URL
    }

    Uri? parsedUri = Uri.tryParse(imageUrl);

    // Check if the parsedUri is a valid absolute URL
    if (parsedUri != null && parsedUri.hasScheme) {
      return imageUrl; 
    }

    // Check if it's a relative path and prepend the base URL
    if (imageUrl.startsWith('/UploadDoctor/')) {
      return "https://doctormap.onrender.com$imageUrl";
    }
    if(imageUrl.startsWith("/Posts/"))
    {
      return "https://doctormap.onrender.com$imageUrl";
    }

    // Handle invalid cases where it's neither a full URL nor a relative path
    return ''; // Or return a placeholder image if needed
  }
}
