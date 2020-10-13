//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:2.0.50727.4927
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// Original file name:
// Generation date: 9/16/2009 7:24:34 PM
namespace CSADONETDataServiceSL3Client.CodeFxService
{
    
    /// <summary>
    /// There are no comments for CodeFxProjects in the schema.
    /// </summary>
    public partial class CodeFxProjects : global::System.Data.Services.Client.DataServiceContext
    {
        /// <summary>
        /// Initialize a new CodeFxProjects object.
        /// </summary>
        public CodeFxProjects(global::System.Uri serviceRoot) : 
                base(serviceRoot)
        {
            this.ResolveName = new global::System.Func<global::System.Type, string>(this.ResolveNameFromType);
            this.ResolveType = new global::System.Func<string, global::System.Type>(this.ResolveTypeFromName);
            this.OnContextCreated();
        }
        partial void OnContextCreated();
        /// <summary>
        /// Since the namespace configured for this service reference
        /// in Visual Studio is different from the one indicated in the
        /// server schema, use type-mappers to map between the two.
        /// </summary>
        protected global::System.Type ResolveTypeFromName(string typeName)
        {
            if (typeName.StartsWith("CSADONETDataService", global::System.StringComparison.Ordinal))
            {
                return this.GetType().Assembly.GetType(string.Concat("CSADONETDataServiceSL3Client.CodeFxService", typeName.Substring(19)), true);
            }
            return null;
        }
        /// <summary>
        /// Since the namespace configured for this service reference
        /// in Visual Studio is different from the one indicated in the
        /// server schema, use type-mappers to map between the two.
        /// </summary>
        protected string ResolveNameFromType(global::System.Type clientType)
        {
            if (clientType.Namespace.Equals("CSADONETDataServiceSL3Client.CodeFxService", global::System.StringComparison.Ordinal))
            {
                return string.Concat("CSADONETDataService.", clientType.Name);
            }
            return null;
        }
        /// <summary>
        /// There are no comments for Projects in the schema.
        /// </summary>
        public global::System.Data.Services.Client.DataServiceQuery<Project> Projects
        {
            get
            {
                if ((this._Projects == null))
                {
                    this._Projects = base.CreateQuery<Project>("Projects");
                }
                return this._Projects;
            }
        }
        private global::System.Data.Services.Client.DataServiceQuery<Project> _Projects;
        /// <summary>
        /// There are no comments for Categories in the schema.
        /// </summary>
        public global::System.Data.Services.Client.DataServiceQuery<Category> Categories
        {
            get
            {
                if ((this._Categories == null))
                {
                    this._Categories = base.CreateQuery<Category>("Categories");
                }
                return this._Categories;
            }
        }
        private global::System.Data.Services.Client.DataServiceQuery<Category> _Categories;
        /// <summary>
        /// There are no comments for Projects in the schema.
        /// </summary>
        public void AddToProjects(Project project)
        {
            base.AddObject("Projects", project);
        }
        /// <summary>
        /// There are no comments for Categories in the schema.
        /// </summary>
        public void AddToCategories(Category category)
        {
            base.AddObject("Categories", category);
        }
    }
    /// <summary>
    /// There are no comments for CSADONETDataService.Project in the schema.
    /// </summary>
    /// <KeyProperties>
    /// ProjectName
    /// </KeyProperties>
    [global::System.Data.Services.Common.DataServiceKeyAttribute("ProjectName")]
    public partial class Project
    {
        /// <summary>
        /// Create a new Project object.
        /// </summary>
        /// <param name="projectName">Initial value of ProjectName.</param>
        public static Project CreateProject(string projectName)
        {
            Project project = new Project();
            project.ProjectName = projectName;
            return project;
        }
        /// <summary>
        /// There are no comments for Property ProjectName in the schema.
        /// </summary>
        public string ProjectName
        {
            get
            {
                return this._ProjectName;
            }
            set
            {
                this.OnProjectNameChanging(value);
                this._ProjectName = value;
                this.OnProjectNameChanged();
            }
        }
        private string _ProjectName;
        partial void OnProjectNameChanging(string value);
        partial void OnProjectNameChanged();
        /// <summary>
        /// There are no comments for Property Owner in the schema.
        /// </summary>
        public string Owner
        {
            get
            {
                return this._Owner;
            }
            set
            {
                this.OnOwnerChanging(value);
                this._Owner = value;
                this.OnOwnerChanged();
            }
        }
        private string _Owner;
        partial void OnOwnerChanging(string value);
        partial void OnOwnerChanged();
        /// <summary>
        /// There are no comments for ProjectCategory in the schema.
        /// </summary>
        public Category ProjectCategory
        {
            get
            {
                return this._ProjectCategory;
            }
            set
            {
                this._ProjectCategory = value;
            }
        }
        private Category _ProjectCategory;
    }
    /// <summary>
    /// There are no comments for CSADONETDataService.Category in the schema.
    /// </summary>
    /// <KeyProperties>
    /// CategoryName
    /// </KeyProperties>
    [global::System.Data.Services.Common.DataServiceKeyAttribute("CategoryName")]
    public partial class Category
    {
        /// <summary>
        /// Create a new Category object.
        /// </summary>
        /// <param name="categoryName">Initial value of CategoryName.</param>
        public static Category CreateCategory(string categoryName)
        {
            Category category = new Category();
            category.CategoryName = categoryName;
            return category;
        }
        /// <summary>
        /// There are no comments for Property CategoryName in the schema.
        /// </summary>
        public string CategoryName
        {
            get
            {
                return this._CategoryName;
            }
            set
            {
                this.OnCategoryNameChanging(value);
                this._CategoryName = value;
                this.OnCategoryNameChanged();
            }
        }
        private string _CategoryName;
        partial void OnCategoryNameChanging(string value);
        partial void OnCategoryNameChanged();
    }
}