//+----------------------------------------------------------------------+
//| Collection de fonctions pour les traitements                         | 
//+----------------------------------------------------------------------+

string ErrorToString(const int error)
{
   switch(error)
   {
      case ERR_NOTIFICATION_SEND_FAILED         : return("ERR_NOTIFICATION_SEND_FAILED");
      case ERR_NOTIFICATION_TOO_FREQUENT        : return("ERR_NOTIFICATION_TOO_FREQUENT");
      case ERR_NOTIFICATION_WRONG_PARAMETER     : return("ERR_NOTIFICATION_WRONG_PARAMETER");
      case ERR_NOTIFICATION_WRONG_SETTINGS      : return("ERR_NOTIFICATION_WRONG_SETTINGS");
      default                                   : return("Erreur non référencée :( !!!");
   }
}

void CleanString(string& i_string)
{
   StringTrimRight(i_string);
   StringTrimLeft(i_string);
}

bool FolderNameControl(const string i_folder, const bool i_backslashVerif = false)
{
   string l_folder;
   ushort l_charactere;
   int l_loop;

   l_folder = i_folder;
   CleanString(l_folder);

   if (l_folder == "") return(false);

   for (l_loop = 0; l_loop < StringLen(l_folder); l_loop++)
   {
      l_charactere = StringGetCharacter(l_folder, l_loop);
      if (l_charactere < ' ') return(false);
      if (l_charactere == '/') return(false);
      if (l_charactere == ':') return(false);
      if (l_charactere == '*') return(false);
      if (l_charactere == '?') return(false);
      if (l_charactere == '<') return(false);
      if (l_charactere == '>') return(false);
      if (l_charactere == '|') return(false);
      if (l_charactere == '"') return(false);
   }
   
   if (i_backslashVerif)
   {
      if (StringSubstr(l_folder, StringLen(l_folder) - 1, 1) != "\\") return(false);
   }
   
   return(true);   
}

bool FileNameControl(const string i_folder)
{
   return(FolderNameControl(i_folder));
}

void SoundNameControl(string& i_sound, const string i_function = "")
{
   if (MQLInfoInteger(MQL_TESTER))
   {
      LOG.INFO("Mode test, Pas de son", __FUNCTION__);
      return;
   }
   
   if (PlaySound(i_sound) == false)
   {
      LOG.WARNING("Fichier son '" + i_sound + "' impossible à jouer. Utilisation d'un fichier son par défaut.", i_function);
      i_sound = "alert2.wav";
      
      if (PlaySound(i_sound) == false)
      {
         LOG.WARNING("Fichier son par défaut '" + i_sound + "' impossible à jouer. Aucun son !!!", i_function);
         i_sound = "";
      }
   }
   
   PlaySound(NULL);
}

string BoolToString(bool value)
{
   return(value ? "Vrai" : "Faux");
}

string ImpactToString(ENUM_IMPACT_LEVEL value)
{
   switch (value)
   {
      case eI_Nothing : return("Aucun");
      case eI_Minor   : return("Mineur");
      case eI_Medium  : return("Moyen");
      case eI_Major   : return("Majeur");
      default         : return("???");
   }
}

string TrendToString(ENUM_TREND trend)
{
   switch(trend)
   {
      case eT_Bull : return("Bull");
      case eT_Bear : return("Bear");
      default      : return("???");
   }
}

string PeriodToString(const ENUM_TIMEFRAMES TF)
{
   ENUM_TIMEFRAMES l_TF = (TF == PERIOD_CURRENT) ? ENUM_TIMEFRAMES(Period()) : TF;

   switch (l_TF)
   {
      case PERIOD_M1  : return("M1");   case PERIOD_M2  : return("M2");
      case PERIOD_M3  : return("M3");   case PERIOD_M4  : return("M4");
      case PERIOD_M5  : return("M5");   case PERIOD_M6  : return("M6");
      case PERIOD_M10 : return("M10");  case PERIOD_M12 : return("M12");
      case PERIOD_M15 : return("M15");  case PERIOD_M20 : return("M20");
      case PERIOD_M30 : return("M30");  case PERIOD_H1  : return("H1");
      case PERIOD_H2  : return("H2");   case PERIOD_H3  : return("H3");
      case PERIOD_H4  : return("H4");   case PERIOD_H6  : return("H6");
      case PERIOD_H8  : return("H8");   case PERIOD_H12 : return("H12");
      case PERIOD_D1  : return("D1");   case PERIOD_W1  : return("W1");
      case PERIOD_MN1 : return("MN1");  default         : return("???");
   }
}
