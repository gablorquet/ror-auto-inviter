<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<UiMod name="rorAutoInviter" version="0.2" date="02/20/2021" >
		<Author name="Artighur" />
		<Description text="Helps group leader with group invites" />
		<VersionSettings gameVersion="1.4.8" windowsVersion="0.1" />
		<Dependencies>
			<Dependency name="EASystem_Utils" />
			<Dependency name="LibSlash" optional="false" forceEnable="true" />
		</Dependencies>

		<Files>
            <File name="rorAutoInviter.lua" />
        </Files>
		
		<OnInitialize>
			<CallFunction name="rorAutoInviter.OnInitialize" />
		</OnInitialize>
		
		<OnShutdown>
			<CallFunction name="rorAutoInviter.OnShutdown" />
		</OnShutdown>

		<SavedVariables>
			<SavedVariable name="rorAutoInviter.Settings" global="false"/>
		</SavedVariables>
		<WARInfo>    
		  <Categories>
			<Category name="RVR" />
		  </Categories>
		</WARInfo>
	</UiMod>
</ModuleFile>